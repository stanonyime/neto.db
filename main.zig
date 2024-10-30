const std = @import("std");

const InputBuffer = struct {
    buffer: []u8,
};

fn newInputBuffer() *InputBuffer {
    return std.heap.page_allocator.create(InputBuffer) catch unreachable;
}

fn closeInputBuffer(input_buffer: *InputBuffer) void {
    std.heap.page_allocator.destroy(input_buffer);
}

fn printPrompt() void {
    std.debug.print("db > ", .{});
}

fn readInput(input_buffer: *InputBuffer) void {
    const stdin = std.io.getStdIn().reader();
    const line = stdin.readAllAlloc(std.heap.page_allocator, 1024) catch {
        std.debug.print("Error reading input\n", .{});
        std.process.exit(1);
    };
    input_buffer.buffer = line;
}

pub fn main() !void {
    const input_buffer = newInputBuffer();
    defer closeInputBuffer(input_buffer);

    while (true) {
        printPrompt();
        readInput(input_buffer);

        if (std.mem.eql(u8, input_buffer.buffer, ".exit")) {
            std.debug.print("Exiting...\n", .{});
            break;
        } else {
            std.debug.print("Unrecognized command '{s}'.\n", .{input_buffer.buffer});
        }
    }
}
