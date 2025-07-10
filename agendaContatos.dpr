program agendaContatos;

uses
  Vcl.Forms,
  uVAgenda in 'View\uVAgenda.pas' {fVAgenda},
  uVContato in 'View\uVContato.pas' {fVContato},
  uMContato in 'Model\uMContato.pas',
  uCContato in 'Controller\uCContato.pas',
  uMRepositorioContato in 'Model\uMRepositorioContato.pas',
  uVInformacoesContatoPai in 'View\uVInformacoesContatoPai.pas' {fVInformacoesContatoPai},
  uVTelefone in 'View\uVTelefone.pas' {fVTelefone},
  uMTelefone in 'Model\uMTelefone.pas',
  Winapi.Windows;

{$R *.res}

begin
//  SetThreadLocale(LOCALE_USER_DEFAULT);
//  SetThreadLocale($0416);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfVAgenda, fVAgenda);
  Application.Run;
end.
