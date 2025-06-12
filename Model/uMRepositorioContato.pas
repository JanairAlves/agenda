unit uMRepositorioContato;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.JSON, uMContato;

type
TMRepositorioContato = class
    private
      function SerializarJson(contato: TMContato): TJsonObject;
      procedure ValidarContato(contato: TMContato);
    public
      constructor Create;
      destructor Destroy; overload;
      procedure Salvar(contato: TMContato);
      function Deletar(id: integer): boolean;
      function ConsultarPorId(id: integer): TMContato;
      function ConsultarTodos: TList;
      function GetIdMaxContatos: integer;
      class function ValidarData(data: string): TDateTime;
  end;

const
 numeroInvalido: integer = -0;
 arquivoContatosJSON: string = 'Contatos.json';

implementation

uses
  System.IOUtils;

{ TMRepositorioContato }

function TMRepositorioContato.ConsultarPorId(id: integer): TMContato;
begin
  //
end;

function TMRepositorioContato.ConsultarTodos: TList;
begin
  //
end;

constructor TMRepositorioContato.Create;
begin
end;

function TMRepositorioContato.Deletar(id: integer): boolean;
begin
  //
end;

destructor TMRepositorioContato.Destroy;
begin
end;

function TMRepositorioContato.GetIdMaxContatos: integer;
var
  contatosJsonArray: TJsonArray;
  itemJSONValue: TJSONValue;
  ProxIdContato: integer;
begin
  result := 0;
  if not TFile.Exists(arquivoContatosJSON) then
    exit;

  contatosJsonArray := TJsonArray.Create;
  try
    try
      contatosJsonArray := TJSONArray(TJsonValue.ParseJSONValue(TFile.ReadAllText(arquivoContatosJSON, TEncoding.UTF8)));

      for itemJSONValue in contatosJsonArray do
      begin
        ProxIdContato := StrToInt(itemJSONValue.FindValue('Id').Value);
        if ProxIdContato > result then
          result := ProxIdContato;
        ProxIdContato := 0;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro obtendo Id max dos contatos. ' + E.Message);
    end;
  finally
    FreeAndNil(contatosJsonArray);
  end;
end;

procedure TMRepositorioContato.Salvar(contato: TMContato);
var
  contatoJsonArray: TJsonArray;
begin
  contatoJsonArray := TJsonArray.Create;

  try
    try
      if TFile.Exists(arquivoContatosJSON) then
        contatoJsonArray := TJSONArray(TJsonValue.ParseJSONValue(TFile.ReadAllText(arquivoContatosJSON, TEncoding.UTF8)));

      contatoJsonArray.Add(SerializarJson(contato));
      TFile.WriteAllText(arquivoContatosJSON, contatoJsonArray.ToString, TEncoding.UTF8);
    except
      on E: Exception do
        raise Exception.Create('Erro ao salvar o contato. Erro: ' + E.Message);
    end;
  finally
    FreeAndNil(contatoJsonArray);
  end;
end;

function TMRepositorioContato.SerializarJson(contato: TMContato): TJsonObject;
begin
  result := TJsonObject.Create;
  try
    result.AddPair('Id', TJsonNumber.Create(GetIdMaxContatos + 1));
    result.AddPair('Nome', TJsonString.Create(contato.Nome));
    result.AddPair('Sobrenome', TJsonString.Create(contato.Sobrenome));
    result.AddPair('Apelido', TJsonString.Create(contato.Apelido));
    result.AddPair('Nascimento', DateToISO8601(contato.Nascimento));
    result.AddPair('Relacionamento', TJsonString.Create(contato.Relacionamento));
    result.AddPair('Excluido', TJsonString.Create(contato.Excluido));
  Except
    on E: Exception do
      raise Exception.Create('Erro na serializar objeto contato\objeto JSON. Erro: ' + E.Message);
  end;
end;

procedure TMRepositorioContato.ValidarContato(contato: TMContato);
begin
  if contato.Id <= 0 then
    raise Exception.Create('Id do contato inválido.');

  if Trim(contato.Nome) = '' then
    raise Exception.Create('O nome do contato não pode ser vázio.');

  if Trim(contato.Relacionamento) = '' then
    raise Exception.Create('O relacionamento precisa ser informado.');

  if Trim(contato.Excluido) = '' then
    raise Exception.Create('A exclusão lógica precisa ser informada com ''S'' ou ''N''.');

  if (contato.Nascimento = -0) then
    raise Exception.Create('Data de nascimento inválida.');
end;

class function TMRepositorioContato.ValidarData(data: string): TDateTime;
begin
  result := numeroInvalido;
  TryStrToDate(data, result);
end;

end.
