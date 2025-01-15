const std = @import("std");

pub const TokenType = enum(u8) {
    DOT, // .
    COMMA, // ,
    COLON, // :
    COLONCOLON, // ::
    SEMICOLON, // ;
    EOF, //

    // Parens
    LPAREN, // (
    RPAREN, // )
    LBRACKET, // [
    RBRACKET, // ]
    LBRACE, // {
    RBRACE, // }

    // Operators
    PLUS, // +
    MINUS, // -
    ASTERISK, // *
    SLASH, // /
    EQ, // =
    EQEQ, // ==
    NOT, // !
    NOTEQ, // !=
    GT, // >
    LT, // <
    GEQ, // >=
    LEQ, // <=
    LSHIFT, // <<
    RSHIFT, // >>

    // Misc
    SLASHSLASH, // //
    UNDERSCORE, // _
};

pub const KeyWords = [_][]const u8{
    "return",
    "for",
    "while",
    "if",
    "else",
    "continue",
    "break",
    "struct",
    "enum",
};

// pub const KeyWords = std.AutoHashMap([]const u8, TokenType);
//
// // Lexical analyzer function (simplified example)
// pub fn lexKeyword(value: []const u8) TokenType {
//     const hashmap = KeyWords{ .data = &[_]std.AutoHashMap.Entry{
//         .key = "return",
//         .value = TokenType.Keyword,
//         .key = "for",
//         .value = TokenType.Keyword,
//         .key = "while",
//         .value = TokenType.Keyword,
//         .key = "if",
//         .value = TokenType.Keyword,
//         .key = "else",
//         .value = TokenType.Keyword,
//         .key = "continue",
//         .value = TokenType.Keyword,
//         .key = "break",
//         .value = TokenType.Keyword,
//         .key = "struct",
//         .value = TokenType.Keyword,
//         .key = "enum",
//         .value = TokenType.Keyword,
//     } };
//
//     // Look up the keyword
//     return hashmap.get(value) orelse TokenType.EOF;
// }

/// Representation of a Token
pub const Token = struct {
    /// Line it's found on
    line: u16,
    /// Column
    col: u8,
    // Its type
    tt: TokenType,
    // Value of said token
    value: []const u8,

    const Self = @This();

    pub fn new(line: u16, col: u8, tt: TokenType, value: []const u8) Self {
        return .{
            .line = line,
            .col = col,
            .tt = tt,
            .value = value,
        };
    }

    pub fn print(self: Self) void {
        std.debug.print("Type: {}, Line: {d}, Column: {d}, Value: {s}\n", .{ self.tt, self.line, self.col, self.value });
    }
};
