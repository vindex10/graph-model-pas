unit graphLib;

interface
  uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls;
  type
    TLinkersList=array of longword;
    Tcoords=record
      x:integer;
      y:integer;
    end;
    graphDot=class
      private
        id:longword;
        dotLabel:string;
        x:integer;
        y:integer;
        linkers:TlinkersList;
        linkers_count:longword;

      public
        procedure setID(id:longword);
        procedure setLabel(s:string);
        procedure setXcoord(x:integer);
        procedure setYcoord(y:integer);
        procedure setCoords(x, y:integer);
        procedure addLinker(id:longword);
        procedure delLinkerById(id:longword);
        procedure delLinkerByNetInd(ind:longword);

        function getID():longword;
        function getLabel():string;
        function getXcoord():integer;
        function getYcoord():integer;
        function getCoords():Tcoords;
        function getLinkersList():TLinkersList;
        function getLinkersCount():longword;

        constructor create();
    end;
    graphLinker=class
      private
        id:longword;
        linkLabel:string;
        weight:longint;
        isOriented:boolean;
        startDot:longword;
        endDot:longword;
      public
        procedure setID(id:longword);
        procedure setLabel(s:string);
        procedure setWeight(m:longint);
        procedure setIsOriented(f:boolean);
        procedure setStartDot(id:longword);
        procedure setEndDot(id:longword);
        procedure doInversion();

        function getID():longword;
        function getLabel():string;
        function getWeight():longint;
        function getIsOriented():boolean;
        function getStartDot():longword;
        function getEndDot():longword;

        constructor create();
    end;
    TDots=array of graphDot;
    TLinkers=array of graphLinker;
    Tgetlinkerbydots=record
      case exists:boolean of
        true:(l:graphLinker);
    end;
    TOrType=set of (lin, lout, lunor);
    TLinkersListStruct=record
      list:array of longword;
      length:longword;
    end;
    graphNet=class
    private
        dots:TDots;
        dots_inc:longword;
        dots_count:longword;
        linkers:Tlinkers;
        linkers_inc:longword;
        linkers_count:longword;
      public
        procedure addDot(d:graphDot);
        procedure delDotById(id:longword);
        procedure delDotByNetInd(ind:longword);
        procedure addLinker(l:graphLinker);
        procedure delLinkerById(id:longword);
        procedure delLinkerByNetInd(ind:longword);

        function getDotById(id:longword):graphDot;
        function getDotByNetInd(ind:longword):graphDot;
        function getDotNetInd(id:longword):longword;
        function getDots():Tdots;
        function getDotsCount():longword;
        function getLinkerById(id:longword):graphLinker;
        function getLinkerByNetInd(ind:longword):graphLinker;
        function getLinkerNetInd(id:longword):longword;
        function getLinkerByDots(id1, id2:longword):TgetLinkerByDots;
        function getLinkers():TLinkers; overload;
        function getLinkers(d:graphDot; s:TOrType):TLinkersListStruct; overload;
        function getLinkersCount():longword;

        constructor create();
    end;

implementation

  //graphDot

  procedure graphDot.setID(id: Cardinal);
  begin
    self.id:=id;
  end;
  procedure graphDot.setLabel(s: string);
  begin
    self.dotLabel:=s;
  end;
  procedure graphDot.setXcoord(x: Integer);
  begin
    self.x:=x;
  end;
  procedure graphDot.setYcoord(y: Integer);
  begin
    self.y:=y;
  end;
  procedure graphDot.setCoords(x: Integer; y: Integer);
  begin
    self.x:=x;
    self.y:=y;
  end;
  procedure graphDot.addLinker(id: Cardinal);
  begin
    inc(self.linkers_count);
    setLength(self.linkers, self.linkers_count);
    self.linkers[self.linkers_count-1]:=id;
  end;
  procedure graphDot.delLinkerById(id: Cardinal);
  var
  i:longword;
  begin
    i:=0;
    while self.linkers[i]<>id do
      inc(i);
    if(i<self.linkers_count-1) then
      for i := i to self.linkers_count-2 do
        self.linkers[i]:=self.linkers[i+1];
    dec(self.linkers_count);
    setLength(self.linkers, self.linkers_count);
  end;
  procedure graphDot.delLinkerByNetInd(ind: Cardinal);
  var i:longword;
  begin
    if(ind<self.linkers_count-1) then
      for i := ind to self.linkers_count-2 do
        self.linkers[i]:=self.linkers[i+1];
    dec(self.linkers_count);
    setLength(self.linkers, self.linkers_count);
  end;


  function graphDot.getID():longword;
  begin
    getID:=self.id;
  end;
  function graphDot.getLabel():string;
  begin
    getLabel:=self.dotLabel;
  end;
  function graphDot.getXcoord():integer;
  begin
    getXcoord:=self.x;
  end;
  function graphDot.getYcoord():integer;
  begin
    getYcoord:=self.y;
  end;
  function graphDot.getCoords():TCoords;
  var
    res:TCoords;
  begin
    res.x:=self.x;
    res.y:=self.y;
    getCoords:=res;
  end;
  function graphDot.getLinkersList():TLinkersList;
  begin
    getLinkersList:=self.linkers;
  end;
  function graphDot.getLinkersCount():longword;
  begin
    getLinkersCount:=self.linkers_count;
  end;

  constructor graphDot.create();
  begin
    self.id:=0;
    self.dotLabel:='???? ???????';
    self.x:=0;
    self.y:=0;
    self.linkers_count:=0;
  end;

  //graphLinker

  procedure graphLinker.setID(id: Cardinal);
  begin
    self.id:=id;
  end;
  procedure graphLinker.setLabel(s: string);
  begin
    self.linkLabel:=s;
  end;
  procedure graphLinker.setWeight(m: Integer);
  begin
    self.weight:=m;
  end;
  procedure graphLinker.setIsOriented(f: Boolean);
  begin
    self.isOriented:=f;
  end;
  procedure graphLinker.setStartDot(id: Cardinal);
  begin
    self.startDot:=id;
  end;
  procedure graphLinker.setEndDot(id: Cardinal);
  begin
    self.endDot:=id;
  end;
  procedure graphLinker.doInversion();
  var
    buf:longword;
  begin
    buf:=self.startDot;
    self.startDot:=self.endDot;
    self.endDot:=buf;
  end;

  function graphLinker.getID():longword;
  begin
    getID:=self.id;
  end;
  function graphLinker.getLabel():string;
  begin
    getLabel:=self.linkLabel;
  end;
  function graphLinker.getWeight():longint;
  begin
    getWeight:=self.weight;
  end;
  function graphLinker.getIsOriented():boolean;
  begin
    getIsOriented:=self.isOriented;
  end;
  function graphLinker.getStartDot():longword;
  begin
    getStartDot:=self.startDot;
  end;
  function graphLinker.getEndDot():longword;
  begin
    getEndDot:=self.endDot;
  end;

  constructor graphLinker.create();
  begin
    self.id:=0;
    self.linkLabel:='???? ?????';
    self.weight:=0;
    self.isOriented:=false;
    self.startDot:=0;
    self.endDot:=0;
  end;

  //graphNet

  procedure graphNet.addDot(d: graphDot);
  begin
    d.setID(self.dots_inc);
    inc(self.dots_inc);
    inc(self.dots_count);
    setLength(self.dots, self.dots_count);
    self.dots[self.dots_count-1]:=d;
  end;
  procedure graphNet.delDotById(id: Cardinal);
  begin
    self.delDotByNetInd(self.getDotNetInd(id));
  end;
  procedure graphNet.delDotByNetInd(ind: Cardinal);
  var i:longword;
  begin
    if(self.dots[ind].getLinkersCount>0) then
    begin
      for I := 0 to self.dots[ind].getLinkersCount-1 do
      begin
        self.delLinkerById(self.dots[ind].getLinkersList[self.dots[ind].getLinkersCount-1]);
      end;
    end;
    if(ind<self.dots_count-1) then
      for i := ind to self.dots_count-2 do
        self.dots[i]:=self.dots[i+1];
    dec(self.dots_count);
    setLength(self.dots, self.dots_count);
  end;
  procedure graphNet.addLinker(l: graphLinker);
  begin
    l.setID(self.linkers_inc);
    self.getDotById(l.getStartDot).addLinker(l.getID);
    self.getDotById(l.getEndDot).addLinker(l.getID);
    inc(self.linkers_count);
    setLength(self.linkers, self.linkers_count);
    inc(self.linkers_inc);
    self.linkers[self.linkers_count-1]:=l;
  end;
  procedure graphNet.delLinkerById(id: Cardinal);
  begin
    self.delLinkerByNetInd(self.getLinkerNetInd(id));
  end;
  procedure graphNet.delLinkerByNetInd(ind: Cardinal);
  var i:longword;
  begin
    self.getDotById(self.linkers[ind].getStartDot).delLinkerById(self.linkers[ind].getID);
    self.getDotById(self.linkers[ind].getEndDot).delLinkerById(self.linkers[ind].getID);
    if(ind<self.linkers_count-1) then
        for I := ind to self.linkers_count-2 do
          self.linkers[i]:=self.linkers[i+1];
    dec(self.linkers_count);
    setLength(self.linkers, self.linkers_count);
  end;

  function graphNet.getDotById(id: Cardinal):graphDot;
  begin
    getDotById:=self.dots[self.getDotNetInd(id)];
  end;
  function graphNet.getDotByNetInd(ind: Cardinal):graphDot;
  begin
    getDotByNetInd:=self.dots[ind];
  end;
  function graphNet.getDotNetInd(id: Cardinal):longword;
  var i:longword;
  begin
    i:=0;
    while id<>self.dots[i].getID do
      inc(i);
    getDotNetInd:=i;
  end;
  function graphNet.getDots():Tdots;
  begin
    getDots:=self.dots;
  end;
  function graphNet.getDotsCount():longword;
  begin
    getDotsCount:=self.dots_count;
  end;
  function graphNet.getLinkerById(id: Cardinal):graphLinker;
  begin
    getLinkerById:=self.linkers[getLinkerNetInd(id)];
  end;
  function graphNet.getLinkerByNetInd(ind: Cardinal):graphLinker;
  begin
    getLinkerByNetInd:=self.linkers[ind];
  end;
  function graphNet.getLinkerByDots(id1: Cardinal; id2: Cardinal):TgetLinkerByDots;
  var
  i:longword;
  j:longword;
  begin
    i:=0;
    result.exists:=false;
    while not(result.exists) and (i<self.getDotById(id1).getLinkersCount) do
    begin
      j:=0;
      while not(result.exists) and (j<self.getDotById(id2).getLinkersCount) do
      begin
        if(self.getDotById(id1).getLinkersList[i]=self.getDotById(id2).getLinkersList[j]) then
        begin
          result.exists:=true;
          result.l:=self.getLinkerById(self.getDotById(id1).getLinkersList[i]);
        end;
        inc(j);
      end;
      inc(i);
    end;
  end;
  function graphNet.getLinkerNetInd(id: Cardinal):longword;
  var i:longword;
  begin
    i:=0;
    if(self.linkers_count>0) then
    begin
      while (self.linkers[i].getID<>id) do
        inc(i);
    end;
    getLinkerNetInd:=i;
  end;
  function graphNet.getLinkers():TLinkers;
  begin
    getLinkers:=self.linkers;
  end;
  function graphNet.getLinkers(d: graphDot; s: TOrType):TLinkersListStruct;
  var
  i:longword;
  r:TLinkersListStruct;
  begin
    r.length:=0;
    setLength(r.list, r.length);
    for i := 0 to d.linkers_count-1 do
    begin
      if (lin in s) and (self.getLinkerById(d.getLinkersList[i]).getEndDot=d.getID) and self.getLinkerById(d.getLinkersList[i]).isOriented then
      begin
        inc(r.length);
        setLength(r.list, r.length);
        r.list[r.length-1]:=(d.getLinkersList)[i];
      end;
      if (lout in s) and (self.getLinkerById(d.getLinkersList[i]).getStartDot=d.getID) and self.getLinkerById(d.getLinkersList[i]).isOriented then
      begin
        inc(r.length);
        setLength(r.list, r.length);
        r.list[r.length-1]:=(d.getLinkersList)[i];
      end;
      if (lunor in s) and not self.getLinkerById(d.getLinkersList[i]).isOriented then
      begin
        inc(r.length);
        setLength(r.list, r.length);
        r.list[r.length-1]:=(d.getLinkersList)[i];
      end;
      result:=r;
    end;

  end;
  function graphNet.getLinkersCount():longword;
  begin
    getLinkersCount:=self.linkers_count;
  end;

  constructor graphNet.create();
  begin
    self.dots_inc:=0;
    self.dots_count:=0;
    self.linkers_inc:=0;
    self.linkers_count:=0;
  end;
end.
