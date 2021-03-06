unit graphDraw;

interface
  uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, graphLib, math;
  const
    DOTRAD=10;
    LNRAD=5;
    ARRANGL=pi/8;
    ARRLEN=15;
  type
  Tisondot=record
    case ison:boolean of
      true:(d:graphDot);
  end;
  TisOnLinker=record
    case ison:boolean of
      true:(l:graphLinker);
  end;
  graphBox=class(TPaintBox)
    private
      procedure drawLinker(l:graphLinker);
      procedure drawDot(d:graphDot);
      function distanceTD(x1, y1, x2, y2:integer):real;
      function distanceTL(x, y, x1, y1, x2, y2:integer):real;
    published
      obj:graphNet;

      procedure drawGraph();

      function isOnDot(x, y:integer):TisOnDot;
      function isOnLinker(x, y:integer):TisOnLinker;

      constructor create(Sender:TObject); reintroduce;
  end;

implementation
  procedure graphBox.drawLinker(l:graphLinker);
  var
  f:real;
  k:shortint;
  begin
    self.Canvas.MoveTo(self.obj.getDotById(l.getStartDot()).getXcoord, self.obj.getDotById(l.getStartDot()).getYcoord);
    self.Canvas.LineTo(self.obj.getDotById(l.getEndDot()).getXcoord, self.obj.getDotById(l.getEndDot()).getYcoord);
    if(l.getIsOriented) then
    begin
      if((self.obj.getDotById(l.getEndDot()).getXcoord-self.obj.getDotById(l.getStartDot()).getXcoord)<>0) then
        f:=arctan((self.obj.getDotById(l.getEndDot()).getYcoord-self.obj.getDotById(l.getStartDot()).getYcoord)/(self.obj.getDotById(l.getEndDot()).getXcoord-self.obj.getDotById(l.getStartDot()).getXcoord))
      else
        f:=pi/2;
      k:=-sign(self.obj.getDotById(l.getStartDot()).getXcoord-self.obj.getDotById(l.getEndDot()).getXcoord);
      self.Canvas.MoveTo(round(self.obj.getDotById(l.getEndDot()).getXcoord-k*DOTRAD*cos(f)), round(self.obj.getDotById(l.getEndDot()).getYcoord-k*DOTRAD*sin(f)));
      self.Canvas.LineTo(round(self.obj.getDotById(l.getEndDot()).getXcoord-k*DOTRAD*cos(f)-k*ARRLEN*cos(k*f+ARRANGL)), round(self.obj.getDotById(l.getEndDot()).getycoord-k*DOTRAD*sin(f)-ARRLEN*sin(k*f+ARRANGL)));
      self.Canvas.MoveTo(round(self.obj.getDotById(l.getEndDot()).getXcoord-k*DOTRAD*cos(f)), round(self.obj.getDotById(l.getEndDot()).getYcoord-k*DOTRAD*sin(f)));
      self.Canvas.LineTo(round(self.obj.getDotById(l.getEndDot()).getXcoord-k*DOTRAD*cos(f)-k*ARRLEN*cos(k*f-ARRANGL)), round(self.obj.getDotById(l.getEndDot()).getycoord-k*DOTRAD*sin(f)-ARRLEN*sin(k*f-ARRANGL)));
    end;
    self.canvas.TextOut(5+(self.obj.getDotById(l.getStartDot()).getXcoord+self.obj.getDotById(l.getEndDot()).getXcoord) div 2, 5+(self.obj.getDotById(l.getStartDot()).getYcoord+self.obj.getDotById(l.getEndDot()).getYcoord) div 2, inttostr(l.getWeight));
  end;
  procedure graphBox.drawDot(d: graphDot);
  begin
    self.Canvas.Ellipse(d.getXcoord-DOTRAD, d.getYcoord+DOTRAD, d.getXcoord+DOTRAD, d.getYcoord-DOTRAD);
    self.Canvas.TextOut(d.getXcoord+DOTRAD, d.getYcoord+DOTRAD, d.getLabel);
  end;
  procedure graphBox.drawGraph();
  var
    i:longword;
  begin
    self.Canvas.Rectangle(0, 0, 500, 500);
    if(self.obj.getLinkersCount>0) then
      for i := 0 to self.obj.getLinkersCount-1 do
        self.drawLinker(self.obj.getLinkerByNetInd(i));
    if(self.obj.getDotsCount>0) then
      for i := 0 to obj.getDotsCount-1 do
        self.drawDot(self.obj.getDotByNetInd(i));
  end;

  constructor graphBox.create(Sender:TObject);
  begin
    inherited create(TComponent(Sender));
    self.obj:=graphNet.create;
  end;


  function graphBox.distanceTD(x1,y1, x2, y2:integer):real;
  begin
    result:=sqrt(sqr(x1-x2)+sqr(y1-y2));
  end;
  function graphBox.distanceTL(x, y, x1, y1, x2, y2:integer):real;
  begin
    result:=abs((x*(y1-y2)-y*(x1-x2)+(y2*x1-x2*y1)))/sqrt(SQR(y1-y2)+sqr(x1-x2));
    result:=min(result, distanceTD(x, y, x1, y1));
    result:=min(result, distanceTD(x, y, x2, y2));
  end;
  function graphBox.isOnDot(x, y:integer):TisOndot;
  var i:longword;
  begin
    i:=0;
    if(self.obj.getDotsCount>0) then
      while (i<self.obj.getDotsCount) and (self.distanceTD(x, y, self.obj.getDotByNetInd(i).getXcoord, self.obj.getDotByNetInd(i).getYcoord)>DOTRAD) do
        inc(i);
    if(i=self.obj.getDotsCount) then
      result.ison:=false
    else
    begin
      result.ison:=true;
      result.d:=self.obj.getDotByNetInd(i);
    end;
  end;
  function graphBox.isOnLinker(x, y:integer):TisOnLinker;
  var i:longword;
  begin
    i:=0;
    if(self.obj.getLinkersCount>0) then
      while (i<self.obj.getLinkersCount) and (self.distanceTL(x, y, self.obj.getDotById(self.obj.getLinkerByNetInd(i).getStartDot).getXcoord, self.obj.getDotById(self.obj.getLinkerByNetInd(i).getStartDot).getYcoord, self.obj.getDotById(self.obj.getLinkerByNetInd(i).getEndDot).getXcoord, self.obj.getDotById(self.obj.getLinkerByNetInd(i).getEndDot).getYcoord)>LNRAD) do
        inc(i);
    if(i=self.obj.getLinkersCount) then
      result.ison:=false
    else
    begin
      result.ison:=true;
      result.l:=self.obj.getLinkerByNetInd(i);
    end;
  end;
end.
