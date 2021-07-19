function detCoor = oxcartConvertRawData(raw,tbin, t0,xbin, center)

tof = raw.tsumx * tbin / 1e3; %[ns]
tof = tof - t0;


detx = raw.detx - center(1);
dety = raw.dety - center(2);

detx = detx * xbin;
dety = dety * xbin;

detCoor = table(detx,dety,tof);