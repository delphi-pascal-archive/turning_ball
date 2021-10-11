program Sharik;{$R-,S-}
uses
Graphics, forms, SysUtils, windows, Classes;
const q=36; //чем больше тем медленее и плавнее
var
ce:tCanvas;
s :pbytearray;
mb:array[1..q] of Graphics.tBitmap;
m :array[0..1200,0..1600{Это макс.размер экрана},1..3] of byte;
mk:array[0..1024,1..768] of record x,y,t:smallInt end;
dx,dy,yc,xc,q256_sy,q256,kx,ky,p,i,j,sx,sy,y,x,z,h,w,sch,scw,xr,x1,x2,y1,y2,t,x3,yr,he2,we2,h2,w2:integer;
kpi2,pi2,r,e,re,rs,rr:real; time:tTimeStamp; pt,pn:tPoint;
b,bw:Graphics.tBitmap;

Procedure izm(var dx:integer);
begin dx:=-dx;if abs(dx)<4 then dx:=dx*2 else if abs(dx)<7 then inc(dx,random(2)-1)end;

begin
sch:=screen.height; he2:=sch div 2;
scw:=screen.width;  we2:=scw div 2;
h:=sch *2 div 3; h2:=h div 2; w:=h; w2:=h2;
ce:=tCanvas.create;
ce.Handle:=GetDC(0);
b:=Graphics.tBitMap.create;b.pixelformat:=pf24bit;b.width:=scw; b.height:=sch;
b.canvas.copyRect(rect(0,0,scw,sch),ce,rect(0,0,scw,sch));
ce.font.size:=18;ce.font.color:=$FF; ce.font.style:=[fsBold];
with b.canvas do begin
//место для вашей рекламы:
font:=ce.font; textOut(we2-60,he2-40,' programania.com ')
end;
y1:=(sch-h)div 2; y2:=sch-y1;
x1:=(scw-w)div 2; x2:=scw-x1;

//Запись экрана в массив цветов
for y:=0 to sch-1 do move(b.ScanLine[y]^,m[y,0,1],scw*3);
//расчет координат 1 раз для всех кадров
pi2:=pi/2; kpi2:=sqrt(pi2); re:=he2;rs:=h2; q256:=256-q div 2;
for y:=1 to h-1 do begin
  for x:=1 to w-1 do begin
    r:=sqrt(sqr(h2-y)+sqr(w2-x));
    if (r>0)and(r<=rs) then begin
      rr:=r/rs;
      e:=ArcTan(sqrt(1-sqr(rr))/rr);
      rr:=(re-re*e/pi2)/r;
      mk[x,y].x:=we2-trunc((w2-x)*rr);
      mk[x,y].y:=he2-trunc((h2-y)*rr);
      mk[x,y].t:=trunc(sqrt(e)*400/kpi2);
    end
    else mk[x,y].t:=-1;
  end;
end;

bw:=graphics.tBitMap.create;  bw.pixelformat:=pf24bit;
bw.width:=w+16; bw.height:=h+16;
GetCursorPos(pn);

time:=DateTimeToTimeStamp(now);
dx:=0; dy:=0; xc:=x1; yc:=y1;

sx:=0;sy:=0;
for i:=1 to q do begin
inc(sx,scw div q);
if i<q div 2 then inc(sy) else dec(sy);

mb[i]:=graphics.tBitMap.create;  mb[i].pixelformat:=pf24bit;
mb[i].width:=w+16; mb[i].height:=h+16;
mb[i].canvas.copyrect(rect(0,0,w+16,h+16),b.canvas,rect(x1,y1,x1+w+16,y1+h+16));

for y:=1 to h-1 do begin
  s:=mb[i].ScanLine[y]; p:=8*3;
  ky:=h2+(y-h2) shl 8 div(q256-sy); q256_sy:=q256+sy;
  if (ky>0)and(ky<h) then
  for x:=1 to w-1 do begin
    kx:=w2+(x-w2) shl 8 div q256_sy;
    if (kx>0)and(kx<w) then begin
    t:=mk[kx,ky].t;
    if t<>-1 then begin
      xr:=mk[kx,ky].x-sx;   if xr<0 then inc(xr,scw);
      yr:=mk[kx,ky].y-sy*2; if yr<0 then inc(yr,sch);
      z:=m[yr,xr,1]*t shr 8; if z>255 then z:=255; s[p]:=z;
      z:=m[yr,xr,2]*t shr 8; if z>255 then z:=255; s[p+1]:=z;
      z:=m[yr,xr,3]*t shr 8; if z>255 then z:=255; s[p+2]:=z;
    end;
    end;
    inc(p,3);
  end;
end;
end;

p:=0;
t:=GetTickCount;
for i:=1 to 30 do
for j:=1 to q do begin ce.draw(x1,y1,mb[j]); inc(p) end;

ce.draw(0,0,b);
t:=(GetTickCount-t)div 1000;
ce.textOut(x1-20,he2-40,' Крутилась '+intToStr(t)+'c. '+
intToStr(p div t)+' fps   Сделай быстрей и красивей! ');
halt;
end.
