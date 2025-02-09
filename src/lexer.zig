const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const File = std.fs.File;

const tok = @import("token.zig");

const Token = tok.Token;
const TT = tok.TokenType;

pub const Lexer = struct {
    const Self = @This();

    tokenList: ArrayList(Token),
    reader: File.Reader = undefined,

    pub fn init(allocator: Allocator) Self {
        return .{
            .tokenList = ArrayList(Token).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.tokenList.deinit();
        self.* = undefined; // added from ziglangset hash_set/managed.zig deinit line 95
    }

    /// Pip
    pub fn lex(self: *Self, reader: File.Reader) !void {
        self.reader = reader;

        var line: u16 = 1;
        var column: u8 = 0;

        while (reader.readByte()) |byte| : (column += 1) {
            switch (byte) {
                '0'...'9' => {
                    // TODO: handle digit better?
                    var num = ArrayList(u8).init(self.tokenList.allocator);
                    defer num.deinit();

                    try num.append(byte);

                    while (self.peek()) |ch| {
                        if (ch >= '0' and ch <= '9' or ch == '.') {
                            try num.append(ch);
                            _ = try reader.readByte();
                            column += 1;
                        } else break;
                    } else |_| {}

                    try self.tokenList.append(Token.new(line, column, TT.NUMBER, try num.toOwnedSlice()));
                },
                'a'...'z', 'A'...'Z' => {
                    // TODO: handle text
                    try self.tokenList.append(Token.new(line, column, TT.LETTER, "a"));
                },
                '.' => {
                    try self.tokenList.append(Token.new(line, column, TT.DOT, "."));
                },

                '\'' => {
                    try self.tokenList.append(Token.new(line, column, TT.QUOTE, "'"));
                },
                '\"' => {
                    try self.tokenList.append(Token.new(line, column, TT.DOUBLEQUOTE, "'"));
                },
                ',' => {
                    try self.tokenList.append(Token.new(line, column, TT.COMMA, ","));
                },
                ':' => {
                    // TODO: Add double colon
                    try self.tokenList.append(Token.new(line, column, TT.COMMA, ":"));
                },
                ';' => {
                    try self.tokenList.append(Token.new(line, column, TT.SEMICOLON, ";"));
                },
                '(' => {
                    try self.tokenList.append(Token.new(line, column, TT.LPAREN, "("));
                },
                ')' => {
                    try self.tokenList.append(Token.new(line, column, TT.RPAREN, ")"));
                },
                '[' => {
                    try self.tokenList.append(Token.new(line, column, TT.LBRACKET, "["));
                },
                ']' => {
                    try self.tokenList.append(Token.new(line, column, TT.RBRACKET, "]"));
                },
                '{' => {
                    try self.tokenList.append(Token.new(line, column, TT.LBRACE, "}"));
                },
                '}' => {
                    try self.tokenList.append(Token.new(line, column, TT.RBRACE, "}"));
                },
                '+' => {
                    try self.tokenList.append(Token.new(line, column, TT.PLUS, "+"));
                },
                '-' => {
                    try self.tokenList.append(Token.new(line, column, TT.MINUS, "-"));
                },
                '*' => {
                    try self.tokenList.append(Token.new(line, column, TT.ASTERISK, "*"));
                },
                '/' => {
                    try self.tokenList.append(Token.new(line, column, TT.SLASH, "/"));
                },
                '=' => {
                    try self.tokenList.append(Token.new(line, column, TT.EQ, "="));
                },
                '!' => {
                    try self.tokenList.append(Token.new(line, column, TT.NOT, "!"));
                },
                '#' => {
                    // COMMENT
                    continue;
                },
                '<' => {
                    try self.tokenList.append(Token.new(line, column, TT.LT, "<"));
                },
                '>' => {
                    try self.tokenList.append(Token.new(line, column, TT.GT, ">"));
                },
                '_' => {
                    try self.tokenList.append(Token.new(line, column, TT.UNDERSCORE, "_"));
                },

                '\n' => {
                    line += 1;
                    column = 0;
                },

                else => unreachable,
            }

            //try self.tokenList.append(byte);
        } else |err| {
            if (err == error.EndOfStream) {
                try self.tokenList.append(Token.new(line, column, TT.EOF, ""));
                // std.log.info("Finished lexing!", .{});
                return;
            } else {
                return err;
            }
        }
    }

    fn peek(self: *Self) !?u8 {
        const pos = try self.reader.getPos();
        const byte = self.reader.readByte() catch |err| {
            return if (err == error.EndOfStream) null else err;
        };

        try self.reader.seekTo(pos);
        return byte;
    }

    fn advance(self: *Self) void {
        self.reader.readByte();
    }

    pub fn printTokens(self: *Self) void {
        for (self.tokenList.items) |token| {
            token.print();
        }
    }
};

pub fn reportError(allocator: Allocator, token: Token, message: []const u8) !void {
    const position = try token.getPosition(allocator);
    defer allocator.free(position);

    try std.io.getStdErr().writer().print("Error at {s} - {s}\n", .{
        position,
        message,
    });
}
