program GraphModel;

uses
  Forms,
  main in 'main.pas' {Form2},
  graphLib in 'graphLib.pas',
  graphDraw in 'graphDraw.pas',
  dijkstra in 'dijkstra.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
