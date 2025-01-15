const std = @import("std");
const testing = std.testing;
const os = std.os;
const fs = std.fs;
const Timer = std.time.Timer;

const utils = @import("utils.zig");
const Unit = utils.Unit;

const Lexer = @import("lexer.zig").Lexer;
const AST = @import("lexer.zig").AST;
const EXTENSION = @import("constants.zig").EXTENSION;
const FileError = @import("constants.zig").FileError;

const DEBUG = true;

pub fn main() !void {
    const args = std.process.argsAlloc(std.heap.page_allocator) catch |err| {
        std.log.err("No args bozo {}", .{err});
        return error.TooFewArgs;
    };

    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 2) return error.TooFewArgs;

    if (DEBUG) {
        for (args) |arg| {
            std.log.info("{s}", .{arg});
        }
    }

    const filename: []const u8 = args[1];

    if (!std.mem.eql(u8, EXTENSION, fs.path.extension(filename))) {
        std.log.debug("Extension {s}", .{fs.path.extension(filename)});
        return error.WrongExtension;
    }

    const file = try fs.cwd().openFile(
        filename,
        .{ .mode = .read_only },
    );
    defer file.close();

    const reader = file.reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var lexer = Lexer.init(allocator);
    defer lexer.deinit();

    var timer = try Timer.start();
    try lexer.lex(reader);
    const end_time = timer.read();

    std.log.info("Time: {:.4}ms", .{utils.fromNs(end_time, Unit.Milliseconds)});

    lexer.printTokens();

    // SCAN / TOKENIZE / LEX

    // MAKE AST

    // AST LOWERING

    // IR

    // LLVM?
}

// test "test all" {}
