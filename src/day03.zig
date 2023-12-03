const std = @import("std");
const utils = @import("utils.zig");

fn getNumber(content: []const u8, i: *usize) i32 {
    var result: i32 = 0;
    var pos: usize = 0;
    while (pos < content.len) : (pos += 1) {
        if (!std.ascii.isDigit(content[pos])) {
            break;
        }
        result = (result * 10) + (content[pos] - '0');
    }
    i.* -= pos;
    return result;
}

fn isSymbol(c: []const u8) bool {
    return !std.ascii.isDigit(c[0]) and !std.mem.eql(u8, c, ".") and !std.mem.eql(u8, c, "\n");
}

fn isStarSymbol(c: []const u8) bool {
    return std.mem.eql(u8, c, "*");
}

fn getHasSymbol(content: []const u8, start: usize, stop: usize, numCols: usize) bool {
    for (start..stop) |i| {
        // left char
        if (i > 0) {
            if (isSymbol(content[i - 1 .. i])) {
                //utils.print("______________________left: {}\n", .{content[i - 1]});
                return true;
            }
        }
        // right char
        if (i < content.len - 1) {
            if (isSymbol(content[i + 1 .. i + 2])) {
                //utils.print("______________________right: {}\n", .{content[i + 1]});
                return true;
            }
        }
        // top char
        if (i > numCols) {
            if (isSymbol(content[i - numCols .. i - numCols + 1])) {
                //utils.print("______________________top: {}\n", .{content[i - numCols]});
                return true;
            }
        }
        // bottom char
        if (i < content.len - numCols) {
            if (isSymbol(content[i + numCols .. i + numCols + 1])) {
                //utils.print("______________________bottom: {}\n", .{content[i + numCols]});
                return true;
            }
        }
        // top left char
        if (i > numCols and i > 0) {
            if (isSymbol(content[i - numCols - 1 .. i - numCols])) {
                //utils.print("______________________top left: {}\n", .{content[i - numCols - 1]});
                return true;
            }
        }
        // top right char
        if (i > numCols and i < content.len - 1) {
            if (isSymbol(content[i - numCols + 1 .. i - numCols + 2])) {
                //utils.print("______________________top right: {}\n", .{content[i - numCols + 1]});
                return true;
            }
        }
        // bottom left char
        if (i < content.len - numCols and i > 0) {
            if (isSymbol(content[i + numCols - 1 .. i + numCols])) {
                //utils.print("______________________bottom left: {}\n", .{content[i + numCols - 1]});
                return true;
            }
        }
        // bottom right char
        if (i < content.len - numCols - 1 and i < content.len - 2) {
            if (isSymbol(content[i + numCols + 1 .. i + numCols + 2])) {
                //utils.print("______________________bottom right: {}\n", .{content[i + numCols + 1]});
                return true;
            }
        }
    }

    return false;
}

fn getHasStarSymbol(content: []const u8, start: usize, stop: usize, numCols: usize) !usize {
    for (start..stop) |i| {
        // left char
        if (i > 0) {
            if (isStarSymbol(content[i - 1 .. i])) {
                //utils.print("______________________left: {}\n", .{content[i - 1]});
                return i - 1;
            }
        }
        // right char
        if (i < content.len - 1) {
            if (isStarSymbol(content[i + 1 .. i + 2])) {
                //utils.print("______________________right: {}\n", .{content[i + 1]});
                return i + 1;
            }
        }
        // top char
        if (i > numCols) {
            if (isSymbol(content[i - numCols .. i - numCols + 1])) {
                //utils.print("______________________top: {}\n", .{content[i - numCols]});
                return i - numCols;
            }
        }
        // bottom char
        if (i < content.len - numCols) {
            if (isStarSymbol(content[i + numCols .. i + numCols + 1])) {
                //utils.print("______________________bottom: {}\n", .{content[i + numCols]});
                return i + numCols;
            }
        }
        // top left char
        if (i > numCols and i > 0) {
            if (isStarSymbol(content[i - numCols - 1 .. i - numCols])) {
                //utils.print("______________________top left: {}\n", .{content[i - numCols - 1]});
                return i - numCols - 1;
            }
        }
        // top right char
        if (i > numCols and i < content.len - 1) {
            if (isStarSymbol(content[i - numCols + 1 .. i - numCols + 2])) {
                //utils.print("______________________top right: {}\n", .{content[i - numCols + 1]});
                return i - numCols + 1;
            }
        }
        // bottom left char
        if (i < content.len - numCols and i > 0) {
            if (isStarSymbol(content[i + numCols - 1 .. i + numCols])) {
                //utils.print("______________________bottom left: {}\n", .{content[i + numCols - 1]});
                return i + numCols - 1;
            }
        }
        // bottom right char
        if (i < content.len - numCols - 1 and i < content.len - 2) {
            if (isStarSymbol(content[i + numCols + 1 .. i + numCols + 2])) {
                //utils.print("______________________bottom right: {}\n", .{content[i + numCols + 1]});
                return i + numCols + 1;
            }
        }
    }

    return error.UnexpectedEof;
}

pub fn solve1(content: []const u8) !i32 {
    var result: i32 = 0;
    var numRows = std.mem.count(u8, content, "\n") + 1;
    var numCols = ((content.len - numRows - 1) / numRows) + 1;
    var i = content.len;

    while (i > 0) : (i -= 1) {
        var pos = content.len - i;
        if (std.ascii.isDigit(content[pos])) {
            var new_i = i;
            var n = getNumber(content[pos..], &new_i);
            var hasSymbol = getHasSymbol(content, pos, content.len - new_i, numCols + 1);
            if (hasSymbol) result += n;
            i = new_i;
        }
    }

    return result;
}

pub fn solve2(content: []const u8) !i32 {
    var result: i32 = 0;
    var numRows = std.mem.count(u8, content, "\n") + 1;
    var numCols = ((content.len - numRows - 1) / numRows) + 1;
    var i = content.len;
    var gears = std.AutoHashMap(usize, std.ArrayList(i32)).init(utils.gpa);
    defer gears.deinit();

    while (i > 0) : (i -= 1) {
        var pos = content.len - i;
        if (std.ascii.isDigit(content[pos])) {
            var new_i = i;
            var n = getNumber(content[pos..], &new_i);
            var gearPosition = getHasStarSymbol(content, pos, content.len - new_i, numCols + 1) catch continue;
            if (gears.contains(gearPosition)) {
                var v = gears.getPtr(gearPosition);
                if (v != null) try v.?.append(n);
            } else {
                var x = std.ArrayList(i32).init(utils.gpa);
                try x.append(n);
                try gears.put(gearPosition, x);
            }
            i = new_i;
        }
    }
    var iterator = gears.iterator();
    while (iterator.next()) |entry| {
        if ((entry.value_ptr.*).items.len == 2) {
            result += (entry.value_ptr.*).items[0] * (entry.value_ptr.*).items[1];
        }
    }

    return result;
}

pub fn main() !void {
    const content = @embedFile("data/day03.txt");
    var result = try solve1(content);
    utils.print("Result 1: {}\n", .{result});
    result = try solve2(content);
    utils.print("Result 2: {}\n", .{result});
}

test "part1 test" {
    const content =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    const result = try solve1(content);
    try std.testing.expectEqual(@as(i32, 4361), result);
}

test "part2 test" {
    const content =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    const result = try solve2(content);
    try std.testing.expectEqual(@as(i32, 467835), result);
}
