unit uMContato;

interface

type
  TMContato = class
    private
      FId: integer;
      FNome: string;
      FSobrenome: string;
      FApelido: string;
      FNascimento: TDate;
      FRelacionamento: string;
      FExcluido: char;
      function GetId: integer;
      function GetNome: string;
      function GetApelido: string;
      function GetExcluido: char;
      function GetNascimento: TDate;
      function GetSobrenome: string;
      function GetRelacionamento: string;
      procedure SetId(const Value: integer);
      procedure SetNome(const Value: string);
      procedure SetExcluido(const Value: char);
      procedure SetApelido(const Value: string);
      procedure SetNascimento(const Value: TDate);
      procedure SetSobrenome(const Value: string);
      procedure SetRelacionamento(const Value: string);
    public
      property Id: integer read GetId write SetId;
      property Nome: string read GetNome write SetNome;
      property Sobrenome: string read GetSobrenome write SetSobrenome;
      property Apelido: string read GetApelido write SetApelido;
      property Nascimento: TDate read GetNascimento write SetNascimento;
      property Relacionamento: string read GetRelacionamento write SetRelacionamento;
      property Excluido: char read GetExcluido write SetExcluido;
  end;

  TMTPRelacoesContato = (
    tpOutros = 0,
    tpFamilia = 1,
    tpTrabalho = 2,
    tpAmigo = 3
    );

    const TMTPRelacoesContatoDescricao: array[TMTPRelacoesContato] of string = (
    'Outros',
    'Família',
    'Trabalho',
    'Amigo'
    );

implementation

{ TMContato }

function TMContato.GetApelido: string;
begin
  result := FApelido;
end;

function TMContato.GetExcluido: char;
begin
  result := FExcluido;
end;

function TMContato.GetId: integer;
begin
  result := FId;
end;

function TMContato.GetNascimento: TDate;
begin
  result := FNascimento;
end;

function TMContato.GetNome: string;
begin
  result := FNome;
end;

function TMContato.GetSobrenome: string;
begin
  result := FSobrenome;
end;

function TMContato.GetRelacionamento: string;
begin
  result := FRelacionamento;
end;

procedure TMContato.SetApelido(const Value: string);
begin
  FApelido := Value;
end;

procedure TMContato.SetExcluido(const Value: char);
begin
  FExcluido := Value;
end;

procedure TMContato.SetId(const Value: integer);
begin
  { Não Implementar esse método, ou Implementar pegar o ID max + 1.}
  FId := value;
end;

procedure TMContato.SetNascimento(const Value: TDate);
begin
  FNascimento := Value;
end;

procedure TMContato.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TMContato.SetSobrenome(const Value: string);
begin
  FSobrenome := Value;
end;

procedure TMContato.SetRelacionamento(const Value: string);
begin
  FRelacionamento := Value;
end;

end.

