function [pos, vel, clk] = satpos(eph, g, sysConfig)

    tk = g.sec - eph.toe.sec;

    if (tk > sysConfig.SECONDS_IN_HALF_WEEK)
        tk = tk - sysConfig.SECONDS_IN_WEEK;
    elseif (tk < -sysConfig.SECONDS_IN_HALF_WEEK)
        tk = tk + sysConfig.SECONDS_IN_WEEK;
    end

    mk = eph.m0 + eph.n*tk;
    ek = mk;
    ekold = ek + 1.0;

    OneMinusecosE = 0; % Suppress the uninitialized warning.
    while (abs(ek - ekold) > 1.0E-14)

        ekold = ek;
        OneMinusecosE = 1.0 - eph.ecc*cos(ekold);
        ek = ek + (mk - ekold + eph.ecc*sin(ekold)) / OneMinusecosE;
    end

    sek = sin(ek);
    cek = cos(ek);

    ekdot = eph.n / OneMinusecosE;

    relativistic = -4.442807633E-10 * eph.ecc * eph.sqrta * sek;

    pk = atan2(eph.sq1e2 * sek, cek - eph.ecc) + eph.aop;
    pkdot = eph.sq1e2 * ekdot / OneMinusecosE;

    s2pk = sin(2.0 * pk);
    c2pk = cos(2.0 * pk);

    uk = pk + eph.cus * s2pk + eph.cuc * c2pk;
    suk = sin(uk);
    cuk = cos(uk);
    ukdot = pkdot * (1.0 + 2.0 * (eph.cus * c2pk - eph.cuc * s2pk));

    rk = eph.A * OneMinusecosE + eph.crc * c2pk + eph.crs * s2pk;
    rkdot = eph.A * eph.ecc * sek * ekdot + 2.0 * pkdot * (eph.crs * c2pk - eph.crc * s2pk);

    ik = eph.inc0 + eph.idot*tk + eph.cic*c2pk + eph.cis*s2pk;
    sik = sin(ik);
    cik = cos(ik);
    ikdot = eph.idot + 2.0*pkdot*(eph.cis*c2pk - eph.cic*s2pk);

    xpk = rk*cuk;
    ypk = rk*suk;
    xpkdot = rkdot*cuk - ypk*ukdot;
    ypkdot = rkdot*suk + xpk*ukdot;

    ok = eph.omg0 + tk*eph.omgkdot - sysConfig.OMEGA_EARTH*eph.toe.sec;
    sok = sin(ok);
    cok = cos(ok);

    pos(1) = xpk*cok - ypk*cik*sok;
    pos(2) = xpk*sok + ypk*cik*cok;
    pos(3) = ypk*sik;

    tmp = ypkdot*cik - ypk*sik*ikdot;

    vel(1) = -eph.omgkdot*pos(2) + xpkdot*cok - tmp*sok;
    vel(2) = eph.omgkdot*pos(1) + xpkdot*sok + tmp*cok;
    vel(3) = ypk*cik*ikdot + ypkdot*sik;

    tk = g.sec - eph.toc.sec;

    if tk > sysConfig.SECONDS_IN_HALF_WEEK
        tk = tk - sysConfig.SECONDS_IN_WEEK;
    elseif tk < -sysConfig.SECONDS_IN_HALF_WEEK
        tk = tk + sysConfig.SECONDS_IN_WEEK;
    end
    clk(1) = eph.af0 + tk * (eph.af1 + tk * eph.af2) + relativistic - eph.tgd;
    clk(2) = eph.af1 + 2.0 * tk * eph.af2;

