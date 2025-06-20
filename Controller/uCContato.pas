unit uCContato;

interface

uses
  DBClient, System.SysUtils, uMContato, System.Classes;

type
  TCContato = class
    private
      FDisplay: TProc<string>;
      function SerializarDatasetMContato(ocdsContato: TClientDataSet): TMContato;
    public
      constructor Create(aValue: TProc<string>);
      destructor Destroy; override;
      procedure SalvarContato(ocdsContato: TClientDataSet);
      function GetRelacoesContato: string;
  end;

implementation

uses
  uMRepositorioContato;

{ TCContato }

constructor TCContato.Create(aValue: TProc<string>);
begin
  FDisplay := aValue;
end;

destructor TCContato.Destroy;
begin
  inherited;
end;

function TCContato.GetRelacoesContato: string;
var
  relacaoContato: TMTPRelacoesContato;
begin
  for relacaoContato := Low(TMTPRelacoesContato) to High(TMTPRelacoesContato) do
    result := result + TMTPRelacoesContatoDescricao[relacaoContato] + ',';
end;

procedure TCContato.SalvarContato(ocdsContato: TClientDataSet);
var
  oMContato: TMContato;
  oMContatoRepositorio: TMRepositorioContato;
begin
  oMContatoRepositorio := TMRepositorioContato.Create;

  try
    try
      oMContato := SerializarDatasetMContato(ocdsContato);
      oMContatoRepositorio.Salvar(oMContato);
    except
      on E: Exception do
      begin
        if assigned(FDisplay) then
          FDisplay('Erro: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(oMContato);
    FreeAndNil(oMContatoRepositorio);
  end;
end;

function TCContato.SerializarDatasetMContato(ocdsContato: TClientDataSet): TMContato;
var
  oMContatoRepositorio: TMRepositorioContato;
begin
  oMContatoRepositorio := TMRepositorioContato.Create;
  result := TMContato.Create;
  
  try
    result.Id := oMContatoRepositorio.GetIdMaxContatos + 1;
    result.Nome := ocdsContato.FieldByName('Nome').AsString;
    result.Sobrenome := ocdsContato.FieldByName('Sobrenome').AsString;
    result.Apelido := ocdsContato.FieldByName('Apelido').AsString;
    result.Nascimento := TMRepositorioContato.ValidarData(
      ocdsContato.FieldByName('Nascimento').AsString);
    result.Relacao := ocdsContato.FieldByName('Relacao').AsString;
    result.Excluido := 'N';
  finally
    FreeAndNil(oMContatoRepositorio);
  end;
end;

end.
