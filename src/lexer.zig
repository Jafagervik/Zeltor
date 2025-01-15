const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const File = std.fs.File;

const tok = @import("token.zig");

const Token = tok.Token;
const TT = tok.TT;

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
        _ = self;
        std.log.info("I am here now", .{});

        while (reader.readByte()) |byte| {
            std.log.info("NOW {any}", .{byte});

            switch (byte) {
                '.' => std.log.info("DOT", .{}),
                else => std.log.info("NO", .{}),
            }

            //try self.tokenList.append(byte);
        } else |err| {
            if (err == error.EndOfStream) {} else {
                return err;
            }
        }
    }

    pub fn printTokens(self: *Self) void {
        for (self.tokenList) |token| {
            std.log.info("{}", .{token});
        }
    }
};
