unit uMRepositorioContato;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.JSON, uMContato;

type
TMRepositorioContato = class
    private
      procedure ValidarContato(contato: TMContato);
      function SerializarJson(contato: TMContato): TJsonObject;
      function ExisteIdContato(var contatosJSONArray: TJSONArray; idContato: integer): boolean;
      function LerArquivoContatos(var contatosJSONArray: TJSONArray): boolean;
    public
      procedure Salvar(contato: TMContato);
      // function Deletar(id: integer): boolean;
      // function ConsultarPorId(id: integer): TMContato;
      // function ConsultarTodos: TList;
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

function TMRepositorioContato.GetIdMaxContatos: integer;
var
  contatosJSONArray: TJSONArray;
  contatoJsonValue: TJSONValue;
  ProxIdContato: integer;
begin
  try
    try
      result := 0;
      if not LerArquivoContatos(contatosJSONArray) then
        exit(result);

      for contatoJsonValue in contatosJSONArray do
      begin
        ProxIdContato := StrToInt(contatoJsonValue.FindValue('Id').Value);
        if ProxIdContato > result then
          result := ProxIdContato;
        ProxIdContato := 0;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro obtendo Id max dos contatos. ' + E.Message);
    end;
  finally
    FreeAndNil(contatosJSONArray);
  end;
end;

procedure TMRepositorioContato.Salvar(contato: TMContato);
var
  contatosJSONArray: TJSONArray;
begin
  try
    try
      if LerArquivoContatos(contatosJSONArray) and ExisteIdContato(contatosJSONArray, contato.Id) then
        raise Exception.Create('Erro, inserção do Id ' + IntToStr(contato.Id) + ' duplicado.');

      contatosJSONArray.Add(SerializarJson(contato));
      TFile.WriteAllText(arquivoContatosJSON, contatosJSONArray.ToString, TEncoding.UTF8);
    except
      on E: Exception do
        raise Exception.Create('Erro ao salvar o contato. Erro: ' + E.Message);
    end;
  finally
    FreeAndNil(contatosJSONArray);
  end;
end;

function TMRepositorioContato.SerializarJson(contato: TMContato): TJsonObject;
begin
  result := TJsonObject.Create;
  try
    result.AddPair('Id', TJsonNumber.Create(contato.Id));
    result.AddPair('Nome', TJsonString.Create(contato.Nome));
    result.AddPair('Sobrenome', TJsonString.Create(contato.Sobrenome));
    result.AddPair('Apelido', TJsonString.Create(contato.Apelido));
    result.AddPair('Nascimento', DateToISO8601(contato.Nascimento));
    result.AddPair('Relacao', TJsonString.Create(contato.Relacao));
    result.AddPair('Excluido', TJsonString.Create(contato.Excluido));
  Except
    on E: Exception do
      raise Exception.Create('Erro na serializar objeto contato\objeto JSON. Erro: ' + E.Message);
  end;
end;

procedure TMRepositorioContato.ValidarContato(contato: TMContato);
begin
  if contato.Id <= 0 then
    raise Exception.Create('Id do contato inv�lido.');

  if Trim(contato.Nome) = '' then
    raise Exception.Create('O nome do contato n�o pode ser v�zio.');

  if Trim(contato.Relacao) = '' then
    raise Exception.Create('A relação precisa ser informado.');

  if Trim(contato.Excluido) = '' then
    raise Exception.Create('A exclus�o l�gica precisa ser informada com ''S'' ou ''N''.');

  if (contato.Nascimento = -0) then
    raise Exception.Create('Data de nascimento inv�lida.');
end;

function TMRepositorioContato.ExisteIdContato(var contatosJSONArray: TJSONArray; idContato: integer): boolean;
var
  contatoJsonValue: TJSONValue;
begin
  result := false;
  for contatoJsonValue in contatosJSONArray do
  begin
    result := StrToInt(contatoJsonValue.FindValue('Id').Value) = idContato;
    if result then
      break;
  end;
end;

function TMRepositorioContato.LerArquivoContatos(var contatosJSONArray: TJSONArray): boolean;
var
  jsonString: string;
  jsonValue: TJsonValue;
begin
  try
    if not TFile.Exists(arquivoContatosJSON) then
      exit(false);

    jsonString := TFile.ReadAllText(arquivoContatosJSON, TEncoding.UTF8);
    if jsonString.Trim.IsEmpty then
      exit(false);

    jsonValue := TJsonValue.ParseJSONValue(jsonString);
    if not (jsonValue is TJSONArray) then
      raise Exception.Create('O arquivo ' + arquivoContatosJSON + ' não é um array JSON válido.');

    contatosJSONArray := TJSONArray(jsonValue);
    if contatosJSONArray = nil then
      raise Exception.Create('O arquivo array JSON ' + arquivoContatosJSON + ' está vazio ou nulo.');

    result := true;
  except
    on E: Exception do
      raise Exception.Create('Erro na leitura do arquivo ' + arquivoContatosJSON + '. Erro: ' + E.Message);
  end;
end;

class function TMRepositorioContato.ValidarData(data: string): TDateTime;
begin
  result := numeroInvalido;
  TryStrToDate(data, result);
end;

end.
