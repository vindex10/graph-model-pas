unit dijkstra;

interface
  uses
    graphLib, Messages;
  type
    Tplength=array of longword;
    TpathTo=array of array of longword;
    TDijkstra=record
      pathLength:Tplength;
      pathTo:TpathTo;
      count:longword;
    end;
  function calcDijkstra(graph:graphNet; d:graphDot):TDijkstra;
implementation
  function calcDijkstra(graph:graphNet; d:graphDot):TDijkstra;
  var
    linkers:TLinkersListStruct;
  i: longword;
  res:TDijkstra;
  begin
    linkers:=graph.getLinkers(d, [lout, lunor]);
    if(linkers.length>0) then
      for i := 0 to linkers.length-1 do
      begin

      end;
  end;
end.
