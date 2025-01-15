pub const Unit = enum {
    Seconds,
    Milliseconds,
};

/// Convert nanoseconds to any other unit
pub fn fromNs(ns: u64, comptime unit: Unit) f64 {
    return switch (unit) {
        .Seconds => @as(f64, @floatFromInt(ns)) / 1_000_000_000.0,
        .Milliseconds => @as(f64, @floatFromInt(ns)) / 1_000_000.0,
    };
}
