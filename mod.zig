const std = @import("std");
const libc = @import("libc").impl;
const errno = @import("errno");

pub const blkcnt_t = libc.blkcnt_t;
pub const blksize_t = libc.blksize_t;
pub const clock_t = libc.clock_t;
pub const clockid_t = libc.clockid_t;
pub const dev_t = libc.dev_t;
pub const fsblkcnt_t = libc.fsblkcnt_t;
pub const fsfilcnt_t = libc.fsfilcnt_t;
pub const gid_t = libc.gid_t;
pub const id_t = libc.id_t;
pub const ino_t = libc.ino_t;
pub const key_t = libc.key_t;
pub const mode_t = libc.mode_t;
pub const nlink_t = libc.nlink_t;
pub const off_t = libc.off_t;
pub const pid_t = libc.pid_t;
pub const pthread_attr_t = libc.pthread_attr_t;
pub const pthread_barrier_t = libc.pthread_barrier_t;
pub const pthread_barrierattr_t = libc.pthread_barrierattr_t;
pub const pthread_cond_t = libc.pthread_cond_t;
pub const pthread_condattr_t = libc.pthread_condattr_t;
pub const pthread_key_t = libc.pthread_key_t;
pub const pthread_mutex_t = libc.pthread_mutex_t;
pub const pthread_mutexattr_t = libc.pthread_mutexattr_t;
pub const pthread_once_t = libc.pthread_once_t;
pub const pthread_rwlock_t = libc.pthread_rwlock_t;
pub const pthread_rwlockattr_t = libc.pthread_rwlockattr_t;
pub const pthread_spinlock_t = libc.pthread_spinlock_t;
pub const pthread_t = libc.pthread_t;
pub const suseconds_t = libc.suseconds_t;
pub const time_t = libc.time_t;
pub const timer_t = libc.timer_t;
pub const trace_attr_t = libc.trace_attr_t;
pub const trace_event_id_t = libc.trace_event_id_t;
pub const trace_event_set_t = libc.trace_event_set_t;
pub const trace_id_t = libc.trace_id_t;
pub const uid_t = libc.uid_t;

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

pub fn readv(fd: c_int, bufs: []const libc.struct_iovec) errno.Error!usize {
    std.debug.assert(bufs.len > 0);
    std.debug.assert(bufs.len <= libc.IOV_MAX);
    const rc = libc.readv(fd, bufs.ptr, @intCast(bufs.len));
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    std.debug.assert(rc >= 0);
    return @intCast(rc);
}

pub fn mkdirat(fd: c_int, path: [*:0]const u8, mode: mode_t) errno.Error!void {
    const rc = libc.mkdirat(fd, path, mode);
    if (rc == -1) return errno.errorFromInt(errno.get_from_libc());
    std.debug.assert(rc == 0);
}
