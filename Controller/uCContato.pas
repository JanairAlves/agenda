unit uCContato;

interface

uses
  DBClient, System.SysUtils, uMContato, System.Classes, uMTelefone, System.Generics.Collections;

type
  TCContato = class
    private
      FDisplay: TProc<string>;
      function SerializarDatasetMContato(poCdsContato: TClientDataSet): TMContato;
      function SerializarDatasetMTelefone(poCdsTelefone: TClientDataSet): TObjectList<TMTelefone>;
    public
      constructor Create(aValue: TProc<string>);
      destructor Destroy; override;
      procedure SalvarContato(poCdsContato, poCdsTelefone: TClientDataSet);
      class function GetRelacoesContato: string;
      class function GetTPLinha: string;
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

class function TCContato.GetRelacoesContato: string;
var
  relacaoContato: TMTPRelacoesContato;
begin
  for relacaoContato := Low(TMTPRelacoesContato) to High(TMTPRelacoesContato) do
    result := result + TMTPRelacoesContatoDescricao[relacaoContato] + ',';
end;

class function TCContato.GetTPLinha: string;
var
  tpLinha: TMTPLinha;
begin
  for tpLinha := Low(TMTPLinha) to High(TMTPLinha) do
    result := result + TMTPLinhaDescricao[tpLinha] + ',';
end;

procedure TCContato.SalvarContato(poCdsContato, poCdsTelefone: TClientDataSet);
var
  oMContato: TMContato;
  oListaTelefonica: TObjectList<TMTelefone>;
  oMContatoRepositorio: TMRepositorioContato;
begin
  oMContatoRepositorio := TMRepositorioContato.Create;

  try
    try
      oMContato := SerializarDatasetMContato(poCdsContato);
      oListaTelefonica := SerializarDatasetMTelefone(poCdsTelefone);

      oMContatoRepositorio.ValidarContato(oMContato);
      oMContatoRepositorio.ValidarTelefone(oListaTelefonica);

      oMContatoRepositorio.Salvar(oMContato, oListaTelefonica);
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
    FreeAndNil(oListaTelefonica);
  end;
end;

function TCContato.SerializarDatasetMContato(poCdsContato: TClientDataSet): TMContato;
var
  oMContatoRepositorio: TMRepositorioContato;
begin
  oMContatoRepositorio := TMRepositorioContato.Create;
  result := TMContato.Create;
  
  try
    result.Id := oMContatoRepositorio.GetIdMaxContatos + 1;
    result.Nome := poCdsContato.FieldByName('Nome').AsString;
    result.Sobrenome := poCdsContato.FieldByName('Sobrenome').AsString;
    result.Apelido := poCdsContato.FieldByName('Apelido').AsString;
    result.Nascimento := TMRepositorioContato.ValidarData(
      poCdsContato.FieldByName('Nascimento').AsString);
    result.Relacao := poCdsContato.FieldByName('Relacao').AsString;
    result.Excluido := 'N';
  finally
    FreeAndNil(oMContatoRepositorio);
  end;
end;

function TCContato.SerializarDatasetMTelefone(poCdsTelefone: TClientDataSet): TObjectList<TMTelefone>;
var
  nContador: integer;
begin
  result := TObjectList<TMTelefone>.Create(true);

  poCdsTelefone.First;
  nContador := 0;

  while not poCdsTelefone.Eof do
  begin
    result.Add(TMTelefone.Create);
    result[nContador].IdTelefone := poCdsTelefone.FieldByName('IdTelefone').AsInteger;
    result[nContador].NuTelefone := poCdsTelefone.FieldByName('NuTelefone').AsString;
    result[nContador].TPLinha := poCdsTelefone.FieldByName('TPLinha').AsString;
    result[nContador].Operadora := poCdsTelefone.FieldByName('Operadora').AsString;
    poCdsTelefone.Next;
    inc(nContador);
  end;
end;

end.
