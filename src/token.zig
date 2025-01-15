const std = @import("std");

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
        std.debug.print("Type: {}, Line: {d}, Column: {d}, Value: {s}", .{ self.tt, self.line, self.col, self.value });
    }
};
