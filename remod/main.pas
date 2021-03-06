unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, graphLib, graphDraw;

type
  TForm2 = class(TForm)
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    curDot:graphDot;
    curLinker:graphLinker;
    procedure checkOnClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure doSelection(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pboxStartMoveDot(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pboxStartMoveDotRight(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pboxMoveDot(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pboxEndMoveDot(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure onChangeType(Sender:TObject);
    procedure pboxMoveLinker(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pboxAddLinker(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure updDotLabel(Sender:TObject);
    procedure updLinkWeight(Sender:TObject);
    procedure updOriented(Sender:TObject);
  public
    pbox:graphBox;
  end;

var
  Form2: TForm2;

implementation
{$R *.dfm}

//Events
procedure TForm2.updOriented(Sender: TObject);
begin
  curLinker.setIsOriented(self.CheckBox1.Checked);
  self.pbox.drawGraph;
end;
procedure TForm2.updDotLabel(Sender:TObject);
begin
  curDot.setLabel(edit1.text);
  self.pbox.drawGraph;
end;
procedure TForm2.updLinkWeight(Sender: TObject);
begin
  curLinker.setWeight(strtoint(edit2.text));
  self.pbox.drawGraph;
end;
procedure TForm2.doSelection(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if(self.pbox.isOnDot(x, y).ison) then
  begin
    self.curDot:=self.pbox.isOnDot(x,y).d;
    self.GroupBox1.Visible:=true;
    self.GroupBox2.Visible:=false;
    self.Edit1.Text:=curDot.getLabel;
    self.button1.Visible:=true;
  end
  else if(self.pbox.isOnLinker(x, y).ison) then
  begin
    self.curLinker:=self.pbox.isOnLinker(x,y).l;
    self.GroupBox1.Visible:=false;
    self.GroupBox2.Visible:=true;
    self.edit2.Text:=inttostr(curLinker.getWeight);
    self.CheckBox1.Checked:=curLinker.getIsOriented;
    self.Button2.Visible:=true;
    self.Button3.Visible:=true;
  end
  else
  begin
    self.GroupBox1.Visible:=false;
    self.GroupBox2.Visible:=false;
  end;
end;
procedure TForm2.pboxStartMoveDot(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(self.pbox.isOnDot(x, y).ison) then
  begin
    self.curDot:=self.pbox.isOnDot(x, y).d;
    self.pbox.OnMouseMove:=self.pboxMoveDot;
  end;
end;
procedure TForm2.pboxStartMoveDotRight(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(self.pbox.isOnDot(x, y).ison) and (button=mbRight) then
  begin
    self.curDot:=self.pbox.isOnDot(x, y).d;
    self.pbox.OnMouseMove:=self.pboxMoveDot;
  end;
end;
procedure TForm2.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  if(button=btNext) then
    self.edit2.Text:=inttostr(strtoint(edit2.text)+1)
  else
    self.edit2.Text:=inttostr(strtoint(edit2.text)-1);
end;

procedure Tform2.pboxEndMoveDot(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  self.pbox.OnMouseMove:=nil;
  if(self.RadioGroup1.ItemIndex=3) then
    self.pbox.onmouseup:=self.doSelection;
end;
procedure Tform2.pboxMoveDot(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
begin
  self.pbox.OnMouseUp:=self.pboxEndMoveDot;
  self.curDot.setCoords(x, y);
  self.pbox.drawGraph;
end;
procedure TForm2.pboxAddLinker(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if(self.pbox.isOnDot(x,y).ison) then
  begin
    curLinker.setEndDot(self.pbox.isOnDot(x, y).d.getID);
    if not(self.pbox.obj.getLinkerByDots(curLinker.getStartDot, curLinker.getEndDot).exists) then
    begin
      self.pbox.obj.addLinker(curLinker);
    end
    else
    begin
      showMessage('??? ???? ????????? ??? ? ?????!');
    end;
  end;
  self.pbox.OnMouseUp:=self.checkOnClick;
  self.pbox.OnMouseMove:=nil;
  curLinker.NewInstance;
  self.pbox.drawGraph;
end;
procedure Tform2.pboxMoveLinker(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
begin
  self.pbox.drawGraph;
  self.pbox.canvas.MoveTo(self.pbox.obj.getDotById(self.curLinker.getStartDot).getXcoord, self.pbox.obj.getDotById(self.curLinker.getStartDot).getYcoord);
  self.pbox.Canvas.LineTo(x, y);
  self.pbox.OnMouseUp:=self.pboxaddLinker;
end;
procedure TForm2.Button1Click(Sender: TObject);
begin
  self.pbox.obj.delDotById(self.curDot.getID);
  curDot.NewInstance;
  self.GroupBox1.Visible:=false;
  self.GroupBox2.Visible:=false;
  self.pbox.drawGraph;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  curLinker.doInversion;
  self.pbox.drawGraph;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  self.pbox.obj.delLinkerById(curLinker.getID);
  curLinker.NewInstance;
  self.GroupBox1.Visible:=false;
  self.GroupBox2.Visible:=false;
  self.pbox.drawGraph;
end;

procedure TForm2.checkOnClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
d:graphDot;
l:graphLinker;
begin
  case self.RadioGroup1.ItemIndex of
    0:
      begin
        if (button=mbLeft) and not(self.pbox.isOnDot(x, y).ison) and not(self.pbox.isOnLinker(x, y).ison) then
        begin
          d:=graphDot.create;
          d.setCoords(x, y);
          d.setLabel(self.Edit1.text);
          self.Edit1.Text:='???? ???????';
          self.pbox.obj.addDot(d);
          self.pbox.drawGraph;
        end
        else if (button=mbRight) and (self.pbox.isOnDot(x, y).ison) then
        begin
          self.pbox.obj.delDotById(self.pbox.isOnDot(x, y).d.getID);
          self.pbox.drawGraph;
        end;
      end;
    2:
      begin
        if (button=mbLeft) and (self.pbox.isOnDot(x, y).ison) then
        begin
          curLinker:=graphLinker.create;
          curLinker.setWeight(strtoint(self.Edit2.text));
          curLinker.setIsOriented(self.CheckBox1.Checked);
          curLinker.setStartDot(self.pbox.isOnDot(x, y).d.getID);
          self.pbox.OnMouseMove:=pboxMoveLinker;
          self.Edit2.Text:='0';
          self.pbox.drawGraph;
        end
        else if (button=mbRight) and (self.pbox.isOnLinker(x, y).ison) and not(self.pbox.isOnDot(x, y).ison) then
        begin
          self.pbox.obj.delLinkerById(self.pbox.isOnLinker(x, y).l.getID);
          self.pbox.drawGraph;
        end;
      end;
  end;
end;

procedure TForm2.onChangeType(Sender: TObject);
begin
  self.Button1.Visible:=false;
  self.Button2.Visible:=false;
  self.Button3.Visible:=false;
  self.Edit1.OnChange:=nil;
  self.Edit2.OnChange:=nil;
  self.CheckBox1.OnClick:=nil;
  case self.RadioGroup1.ItemIndex of
    0:begin
      self.GroupBox2.Visible:=false;
      self.GroupBox1.Visible:=true;
      self.pbox.OnmouseUp:=self.checkOnClick;
      self.pbox.onmousedown:=nil;
    end;
    1:begin
      self.GroupBox2.Visible:=false;
      self.GroupBox1.Visible:=false;
      self.pbox.OnmouseUp:=nil;
      self.pbox.onmousedown:=self.pboxStartMoveDot;
    end;
    2:begin
      self.GroupBox1.Visible:=false;
      self.GroupBox2.Visible:=true;
      self.pbox.OnmouseUp:=self.checkOnClick;
      self.pbox.onmousedown:=nil;
    end;
    3:begin
      self.GroupBox1.Visible:=false;
      self.GroupBox2.Visible:=false;
      self.pbox.OnMouseDown:=self.pboxStartMoveDotRight;
      self.pbox.OnMouseUp:=self.doSelection;
      self.Edit1.OnChange:=self.updDotLabel;
      self.Edit2.OnChange:=self.updLinkWeight;
      self.CheckBox1.OnClick:=self.updOriented;
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
l:graphLinker;
d:graphDot;
begin
  self.pbox:=graphBox.create(self);
  self.pbox.ParentColor:=false;
  self.pbox.Parent:=self;
  self.pbox.Name:='PBOX';
  self.pbox.Height:=500;
  self.pbox.Width:=500;
  self.pbox.Left:=10;
  self.pbox.Top:=10;
  self.pbox.Canvas.Brush.Color:=clwhite;
  self.pbox.Canvas.Pen.Color:=clred;
  self.pbox.onMouseUp:=self.checkOnClick;

  self.RadioGroup1.OnClick:=self.onChangeType;
end;

procedure TForm2.FormPaint(Sender: TObject);
begin
  pbox.drawGraph;
end;
end.
