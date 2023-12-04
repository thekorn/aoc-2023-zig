const std = @import("std");
const utils = @import("utils.zig");

fn playGame(game: []const u8) !i32 {
    var cardIter = std.mem.tokenize(u8, game, "|");

    var myCards = cardIter.next().?;
    var winningCards = cardIter.next().?;

    utils.print("----> {?} \n", .{myCards});
    utils.print("----> {?} \n", .{winningCards});
    return 0;
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
    var gameIter = std.mem.tokenize(u8, content, "\n");
    var currentGame: i32 = 1;
    var result: i32 = 0;
    while (gameIter.next()) |game| : (currentGame += 1) {
        var p = std.mem.indexOf(u8, game, ":");
        if (p == null) {
            return error.UnexpectedEof;
        }
        var points = try playGame(game[p.? + 2 ..]);
        _ = points;
        result += currentGame;
    }
    return result;
}

pub fn solve2(content: []const u8) !i32 {
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
    const content = @embedFile("data/day04.txt");
    var result = try solve1(content);
    utils.print("Result 1: {?}\n", .{result});
    //result = try solve2(content);
    //utils.print("Result 2: {}\n", .{result});
}

test "part1 test" {
    const content =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    const result = try solve1(content);
    try std.testing.expectEqual(@as(i32, 13), result);
}

//test "part2 test" {
//    const content =
//        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//    ;
//    const result = try solve2(content);
//    try std.testing.expectEqual(@as(i32, 2286), result);
//}
