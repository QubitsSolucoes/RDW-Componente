object dmFileServer: TdmFileServer
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 239
  Width = 351
  object dwSEArquivos: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBlob
            ParamName = 'result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'FileList'
        OnReplyEvent = dwSEArquivosEventsFileListReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Arquivo'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Diretorio'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovBlob
            ParamName = 'FileSend'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBoolean
            ParamName = 'Result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'SendReplicationFile'
        OnReplyEvent = dwSEArquivosEventsSendReplicationFileReplyEvent
      end
      item
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Arquivo'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovBlob
            ParamName = 'Result'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'DownloadFile'
        OnReplyEvent = dwSEArquivosEventsDownloadFileReplyEvent
      end>
    Left = 80
    Top = 103
  end
end
