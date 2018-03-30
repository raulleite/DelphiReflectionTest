unit uIConnection;

interface

type
  IConnection = Interface
  ['{94DF90F5-B501-4B05-B6E8-EF0C10165F6B}']
    function startTransaction: Boolean;
    function commitTransaction: Boolean;
  end;

implementation

end.
