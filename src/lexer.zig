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

    pub fn init(allocator: Allocator) Self {
        return .{
            .tokenList = ArrayList(Token).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.tokenList.deinit();
    }

    /// Pip
    pub fn lex(self: *Self, reader: File.Reader) !void {
        std.log.info("Lexing..", .{});

        var line: u16 = 1;
        var column: u8 = 0;

        while (reader.readByte()) |byte| : (column += 1) {
            switch (byte) {
                '.' => {
                    try self.tokenList.append(Token.new(line, column, TT.DOT, "."));
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

                '\n' => {
                    line += 1;
                    column = 0;
                },
                else => std.log.info("???", .{}),
            }

            //try self.tokenList.append(byte);
        } else |err| {
            if (err == error.EndOfStream) {
                try self.tokenList.append(Token.new(line, column, TT.EOF, ""));
                std.log.info("Finished lexing!", .{});
                return;
            } else {
                return err;
            }
        }
    }

    fn peek(self: *Self) u8 {
        _ = self;
        return 0;
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
