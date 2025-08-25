const std = @import("std");
const libc = @import("libc").impl;
const errno = @import("errno");

pub const pid_t = libc.pid_t;
pub const AT = libc.AT;
pub const O = libc.O;

pub fn getpid() pid_t {
    return libc.getpid();
}

pub fn exit(status: c_int) noreturn {
    return libc.exit(status);
}

pub fn getenv(name: [:0]const u8) ?[:0]u8 {
    return std.mem.sliceTo(libc.getenv(name.ptr) orelse return null, 0);
}

pub fn openat(fd: c_int, file: [*:0]const u8, oflag: c_int) errno.Error!c_int {
    const rc = libc.openat(fd, file, oflag);
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    return rc;
}

pub fn close(fd: c_int) errno.Error!void {
    const rc = libc.close(fd);
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    std.debug.assert(rc == 0);
}

pub fn read(fd: c_int, buf: []u8) errno.Error!usize {
    const rc = libc.read(fd, buf.ptr, buf.len);
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    std.debug.assert(rc >= 0);
    return @intCast(rc);
}

pub fn fstat(fd: c_int) errno.Error!libc.struct_stat {
    var buf: libc.struct_stat = undefined;
    const rc = libc.fstat(fd, &buf);
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    std.debug.assert(rc == 0);
    return buf;
}
