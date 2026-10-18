program Tests;

{$APPTYPE CONSOLE}

// Compile com o diretorio "..\Cadastro Com RTTI" no Search Path do projeto
// (Project > Options > Delphi Compiler > Search path).

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  TestSQLBuilder in 'TestSQLBuilder.pas',
  TestValidador in 'TestValidador.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
begin
  try
    TDUnitX.CheckCommandLine;
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
