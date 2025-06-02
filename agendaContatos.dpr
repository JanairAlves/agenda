program agendaContatos;

uses
  Vcl.Forms,
  uVAgenda in 'View\uVAgenda.pas' {fVAgenda},
  uVContato in 'View\uVContato.pas' {fVContato},
  uMContato in 'Model\uMContato.pas',
  uMRelacionamento in 'Model\uMRelacionamento.pas',
  uCContato in 'Controller\uCContato.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfVAgenda, fVAgenda);
  Application.CreateForm(TfVContato, fVContato);
  Application.Run;
end.
