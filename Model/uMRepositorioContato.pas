unit uMRepositorioContato;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, System.JSON, uMContato,
  uMTelefone, System.Generics.Collections;

type
TMRepositorioContato = class
    private
      function SerializarJsonContato(poContato: TMContato; poListaTelefonica: TObjectList<TMTelefone>): TJsonObject;
      function SerializarJsonListaTelefonica(poListaTelefonica: TObjectList<TMTelefone>): TJSONArray;
      function ExisteIdContato(var poContatosJSONArray: TJSONArray; pnIdContato: integer): boolean;
      function LerArquivoContatos(var poContatosJSONArray: TJSONArray): boolean;
    public
      procedure Salvar(poContato: TMContato; poListaTelefonica: TObjectList<TMTelefone>);
      // function Deletar(id: integer): boolean;
      // function ConsultarPorId(id: integer): TMContato;
      // function ConsultarTodos: TList;
      procedure ValidarContato(poContato: TMContato);
      procedure ValidarTelefone(poListaTelefonica: TObjectList<TMTelefone>);
      function GetIdMaxContatos: integer;
      class function ValidarData(psData: string): TDateTime;
  end;

const
 numeroInvalido: integer = -0;
 arquivoContatosJSON: string = 'Contatos.json';

implementation

uses
  System.IOUtils, System.RegularExpressions;

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

procedure TMRepositorioContato.Salvar(poContato: TMContato; poListaTelefonica: TObjectList<TMTelefone>);
var
  oContatoJSONArray: TJSONArray;
begin
  try
    try
      if LerArquivoContatos(oContatoJSONArray) and ExisteIdContato(oContatoJSONArray, poContato.Id) then
        raise Exception.Create('Erro, inserção do Id ' + IntToStr(poContato.Id) + ' duplicado.');

      oContatoJSONArray.Add(SerializarJsonContato(poContato, poListaTelefonica));
      TFile.WriteAllText(arquivoContatosJSON, oContatoJSONArray.ToString, TEncoding.UTF8);
    except
      on E: Exception do
        raise Exception.Create('Erro ao salvar o contato. Erro: ' + E.Message);
    end;
  finally
    FreeAndNil(oContatoJSONArray);
  end;
end;

function TMRepositorioContato.SerializarJsonContato(poContato: TMContato; poListaTelefonica: TObjectList<TMTelefone>): TJsonObject;
begin
  result := TJsonObject.Create;
  try
    result.AddPair('Id', TJSONNumber.Create(poContato.Id));
    result.AddPair('Nome', TJSONString.Create(poContato.Nome));
    result.AddPair('Sobrenome', TJSONString.Create(poContato.Sobrenome));
    result.AddPair('Apelido', TJSONString.Create(poContato.Apelido));
    result.AddPair('Nascimento', DateToISO8601(poContato.Nascimento));
    result.AddPair('Relacao', TJSONString.Create(poContato.Relacao));
    result.AddPair('Excluido', TJSONString.Create(poContato.Excluido));
    if not poListaTelefonica.IsEmpty then
      result.AddPair('ListaTelefonica', SerializarJsonListaTelefonica(poListaTelefonica));
  Except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao serializar objeto contato\objeto JSON. Erro: ' + E.Message);
  end;
end;

function TMRepositorioContato.SerializarJsonListaTelefonica(poListaTelefonica: TObjectList<TMTelefone>): TJSONArray;
var
  oTelefone: TMTelefone;
  oTelefoneJson: TJSONObject;
begin
  result := TJSONArray.Create;

  for oTelefone in poListaTelefonica do
  begin
    oTelefoneJson := TJSONObject.Create;
    oTelefoneJson.AddPair('IdTelefone', TJSONNumber.Create(oTelefone.IdTelefone));
    oTelefoneJson.AddPair('NuTelefone', TJSONString.Create(oTelefone.NuTelefone));
    oTelefoneJson.AddPair('TPLinha', TJSONString.Create(oTelefone.TPLinha));
    oTelefoneJson.AddPair('Operadora', TJSONString.Create(oTelefone.Operadora));
    result.Add(oTelefoneJson);
    oTelefoneJson := nil;
  end;
end;

procedure TMRepositorioContato.ValidarContato(poContato: TMContato);
begin
  if poContato.Id <= 0 then
    raise Exception.Create('Id do contato inválido.');

  if Trim(poContato.Nome) = '' then
    raise Exception.Create('O nome do contato não pode ser vázio.');

  if Trim(poContato.Relacao) = '' then
    raise Exception.Create('A relação precisa ser informada.');

  if Trim(poContato.Excluido) = '' then
    raise Exception.Create('A exclusão lógica precisa ser informada com ''S'' ou ''N''.');

  if (poContato.Nascimento = -0) then
    raise Exception.Create('Data de nascimento inválida.');
end;

procedure TMRepositorioContato.ValidarTelefone(poListaTelefonica: TObjectList<TMTelefone>);
var
  nuTelefone: string;
  oTelefone: TMTelefone;
begin
  for oTelefone in poListaTelefonica do
  begin
    if oTelefone.IdTelefone <= 0 then
      raise Exception.Create('Id telefone não foi informado.');

    if Trim(oTelefone.TPLinha) = '' then
      raise Exception.Create('O tipo de linha não pode ser um valor vázio.');

    nuTelefone := TRegEx.Replace(oTelefone.NuTelefone, '[\s\(\)\-]', '', [roIgnoreCase]);
    if nuTelefone = '' then
      raise Exception.Create('Número de telefone precisa ser informado.');

    if (Trim(oTelefone.TPLinha) = 'Fixo') and (Length(nuTelefone) <> 10) then
        raise Exception.Create('Telefone fixo precisa ser 10 números, no formato (99) 9999-9999');

    if (Trim(oTelefone.TPLinha) = 'Celular') and (Length(nuTelefone) <> 11) then
      raise Exception.Create('Telefone celular precisa ser 11 números, no formato (99) 9 9999-9999.');

    if (Trim(oTelefone.TPLinha) = 'Celular') and (StrToInt(nuTelefone[3]) <> 9) then
      raise Exception.Create('Terceiro digito do celular precisar ser o número 9, no formato (99) 9 9999-9999.');

    oTelefone.NuTelefone := nuTelefone;

    if Trim(oTelefone.Operadora) = '' then
      raise Exception.Create('A operadora não pode ser vázio.');
  end;
end;

function TMRepositorioContato.ExisteIdContato(var poContatosJSONArray: TJSONArray; pnIdContato: integer): boolean;
var
  contatoJsonValue: TJSONValue;
begin
  result := false;
  for contatoJsonValue in poContatosJSONArray do
  begin
    result := StrToInt(contatoJsonValue.FindValue('Id').Value) = pnIdContato;
    if result then
      break;
  end;
end;

function TMRepositorioContato.LerArquivoContatos(var poContatosJSONArray: TJSONArray): boolean;
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

    poContatosJSONArray := TJSONArray(jsonValue);
    if poContatosJSONArray = nil then
      raise Exception.Create('O arquivo array JSON ' + arquivoContatosJSON + ' está vazio ou nulo.');

    result := true;
  except
    on E: Exception do
      raise Exception.Create('Erro na leitura do arquivo ' + arquivoContatosJSON + '. Erro: ' + E.Message);
  end;
end;

class function TMRepositorioContato.ValidarData(psData: string): TDateTime;
begin
  result := numeroInvalido;
  TryStrToDate(psData, result);
end;

end.
