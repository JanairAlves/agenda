unit uMTelefone;

interface

type
    TMTelefone = class
        private
            FIdTelefone: Integer;
            FNuTelefone: string;
            FTPLinha: string;
            FOperadora: string;
            function GetIdTelefone: integer;
            function GetNuTelefone: string;
            function GetTPLinha: string;
            function GetOperadora: string;
            procedure SetIdTelefone(const Value: Integer);
            procedure SetNuTelefone(const Value: string);
            procedure SetTPLinha(const Value: string);
            procedure SetOperadora(const Value: string);
        public
            property NuTelefone: string read GetNuTelefone write SetNuTelefone;
            property TPLinha: string read GetTPLinha write SetTPLinha;
            property Operadora: string read GetOperadora write SetOperadora;
            property IdTelefone: integer read GetIdTelefone write SetIdTelefone;
    end;

    TMTPLinha = (
        tpFixo = 0,
        tpCelular = 1
    );

    const TMTPLinhaDescricao: array[TMTPLinha] of string = (
        'Fixo',
        'Móvel'
    );

implementation

{ TMTelefone }

function TMTelefone.GetOperadora: string;
begin
    result := FOperadora;
end;

function TMTelefone.GetIdTelefone: integer;
begin
  result := FIdTelefone;
end;

function TMTelefone.GetNuTelefone: string;
begin
    result := FNuTelefone;
end;

function TMTelefone.GetTPLinha: string;
begin
    result := FTPLinha;
end;

procedure TMTelefone.SetOperadora(const Value: string);
begin
    FOperadora := Value;
end;

procedure TMTelefone.SetIdTelefone(const Value: Integer);
begin
  FIdTelefone := Value;
end;

procedure TMTelefone.SetNuTelefone(const Value: string);
begin
    FNuTelefone := Value;
end;

procedure TMTelefone.SetTPLinha(const Value: string);
begin
    FTPLinha := Value;
end;

end.
