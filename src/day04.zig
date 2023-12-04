const std = @import("std");
const utils = @import("utils.zig");

fn playGame(game: []const u8) !i32 {
    var cardIter = std.mem.tokenize(u8, game, "|");

    var myCards = cardIter.next().?;
    var winningCards = cardIter.next().?;

    var myCardIter = std.mem.tokenizeAny(u8, myCards, " ");
    var winningCardIter = std.mem.tokenizeAny(u8, winningCards, " ");

    var winningNumbers = std.AutoHashMap(i32, void).init(utils.gpa);
    defer winningNumbers.deinit();

    while (winningCardIter.next()) |card| {
        var n = try std.fmt.parseInt(i32, card, 10);
        try winningNumbers.put(n, {});
    }

    var numMatches: i32 = 0;
    while (myCardIter.next()) |card| {
        var n = try std.fmt.parseInt(i32, card, 10);
        if (winningNumbers.contains(n)) {
            numMatches += 1;
        }
    }

    if (numMatches > 0) {
        return std.math.pow(i32, 2, numMatches - 1);
    }
    return 0;
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
        result += points;
    }
    return result;
}

pub fn solve2(content: []const u8) !i32 {
    _ = content;
    return 0;
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

test "part2 test" {
    const content =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    const result = try solve2(content);
    try std.testing.expectEqual(@as(i32, 30), result);
}
