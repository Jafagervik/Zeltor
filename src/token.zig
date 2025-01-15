pub const TokenType = enum {
    DOT,
    COMMA,
    SEMICOLON,
};

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
};
