var buf: [256]u8 = undefined;
    h_original.write(&buf);

    const h_received = protocol.Header.read(&buf);
    print("received: {any}\n", .{h_received});