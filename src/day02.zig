const std = @import("std");
const utils = @import("utils.zig");

fn isGamePossible(game: []const u8) !bool {
    var roundIter = std.mem.tokenize(u8, game, ";");
    while (roundIter.next()) |round| {
        var redQuota: i32 = 12;
        var greeQuota: i32 = 13;
        var blueQuota: i32 = 14;
        var boxIter = std.mem.tokenize(u8, round, ",");
        while (boxIter.next()) |box| {
            var b = std.mem.trim(u8, box, " ");
            //utils.print("{}: '{s}'\n", .{ currentGame, b });
            var bIter = std.mem.tokenize(u8, b, " ");
            var cnt: i32 = try std.fmt.parseInt(i32, bIter.next().?, 10);
            var color = bIter.next();
            //utils.print("{}: '{any}' '{any}'\n", .{ currentGame, cnt, color });

            if (std.mem.eql(u8, color.?, "red")) {
                redQuota -= cnt;
                if (redQuota < 0) return false;
            } else if (std.mem.eql(u8, color.?, "green")) {
                greeQuota -= cnt;
                if (greeQuota < 0) return false;
            } else if (std.mem.eql(u8, color.?, "blue")) {
                blueQuota -= cnt;
                if (blueQuota < 0) return false;
            } else {
                return error.UnexpectedEof;
            }
        }
    }

    //utils.print("----> {} {} {} <== {s}\n", .{ redQuota, greeQuota, blueQuota, game });
    return true;
}

fn getMinBoxCnt(game: []const u8) !i32 {
    var redQuota: i32 = 0;
    var greeQuota: i32 = 0;
    var blueQuota: i32 = 0;
    var roundIter = std.mem.tokenize(u8, game, ";");
    while (roundIter.next()) |round| {
        var boxIter = std.mem.tokenize(u8, round, ",");
        while (boxIter.next()) |box| {
            var b = std.mem.trim(u8, box, " ");
            //utils.print("{}: '{s}'\n", .{ currentGame, b });
            var bIter = std.mem.tokenize(u8, b, " ");
            var cnt: i32 = try std.fmt.parseInt(i32, bIter.next().?, 10);
            var color = bIter.next();
            //utils.print("{}: '{any}' '{any}'\n", .{ currentGame, cnt, color });

            if (std.mem.eql(u8, color.?, "red")) {
                redQuota = @max(redQuota, cnt);
            } else if (std.mem.eql(u8, color.?, "green")) {
                greeQuota = @max(greeQuota, cnt);
            } else if (std.mem.eql(u8, color.?, "blue")) {
                blueQuota = @max(blueQuota, cnt);
            } else {
                return error.UnexpectedEof;
            }
        }
    }

    //utils.print("----> {} {} {} <== {s}\n", .{ redQuota, greeQuota, blueQuota, game });

    return redQuota * greeQuota * blueQuota;
}

pub fn solve1(content: []const u8) !i32 {
    var lines = std.ArrayList([]const u8).init(utils.gpa);
    defer lines.deinit();
    var gameIter = std.mem.tokenize(u8, content, "\n");
    var currentGame: i32 = 1;
    var result: i32 = 0;
    while (gameIter.next()) |game| : (currentGame += 1) {
        var p = std.mem.indexOf(u8, game, ":");
        if (p == null) {
            return error.UnexpectedEof;
        }
        var canPlayGame = try isGamePossible(game[p.? + 2 ..]);
        //utils.print("{}: {}\n", .{ currentGame, canPlayGame });
        if (canPlayGame) {
            result += currentGame;
        }
    }
    return result;
}

pub fn solve2(content: []const u8) !i32 {
    var lines = std.ArrayList([]const u8).init(utils.gpa);
    defer lines.deinit();
    var gameIter = std.mem.tokenize(u8, content, "\n");
    var currentGame: i32 = 1;
    var result: i32 = 0;
    while (gameIter.next()) |game| : (currentGame += 1) {
        var p = std.mem.indexOf(u8, game, ":");
        if (p == null) {
            return error.UnexpectedEof;
        }
        result += try getMinBoxCnt(game[p.? + 2 ..]);
    }
    return result;
}

pub fn main() !void {
    const content = @embedFile("data/day02.txt");
    var result = try solve1(content);
    utils.print("Result 1: {}\n", .{result});
    result = try solve2(content);
    utils.print("Result 2: {}\n", .{result});
}

test "part1 test" {
    const content =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const result = try solve1(content);
    try std.testing.expectEqual(@as(i32, 8), result);
}

test "part2 test" {
    const content =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const result = try solve2(content);
    try std.testing.expectEqual(@as(i32, 2286), result);
}
