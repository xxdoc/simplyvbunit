VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TestOutputWriter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' Copyright 2010 Kelly Ethridge
'
' Licensed under the Apache License, Version 2.0 (the "License");
' you may not use this file except in compliance with the License.
' You may obtain a copy of the License at
'
'     http://www.apache.org/licenses/LICENSE-2.0
'
' Unless required by applicable law or agreed to in writing, software
' distributed under the License is distributed on an "AS IS" BASIS,
' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
' See the License for the specific language governing permissions and
' limitations under the License.
'
' Module: TestOutputWriter
'
Option Explicit
Implements ITextWriter

Private mListener   As IEventListener
Private mOutputType As TestOutputType
Private mBuffer     As New StringBuilder


Public Sub WriteText(ByRef Text As String, ParamArray Args() As Variant)
    WriteTextDirect(Text) = Args
End Sub

Public Sub WriteLine(ParamArray TextAndArgs() As Variant)
    WriteLineDirect = TextAndArgs
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Friend Methods
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Friend Sub Init(ByVal Listener As IEventListener, ByVal OutputType As TestOutputType)
    If Listener Is Nothing Then _
        Err.Raise ErrorCode.ArgumentNull, "TestOutputWriter", "Listener cannot be Nothing."
    
    Set mListener = Listener
    mOutputType = OutputType
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Private Helpers
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Property Let WriteTextDirect(ByRef Text As String, ByVal Args As Variant)
    mBuffer.Length = 0
    Dim LocalArgs() As Variant
    LocalArgs = Args
    mBuffer.AppendFormatArray Text, LocalArgs
    OutputText
End Property

Private Property Let WriteLineDirect(ByVal TextAndArgs As Variant)
    mBuffer.Length = 0
    Dim LocalArgs() As Variant
    LocalArgs = TextAndArgs
    mBuffer.AppendFormatArrayEx LocalArgs
    mBuffer.Append vbCrLf
    OutputText
End Property

Private Sub OutputText()
    Dim Output As TestOutput
    Set Output = Sim.NewTestOutput(mBuffer.ToString, mOutputType)
    mListener.TestOutput Output
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   ITextWriter Interface
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub ITextWriter_WriteLine(ParamArray TextAndArgs() As Variant)
    WriteLineDirect = TextAndArgs
End Sub

Private Sub ITextWriter_WriteText(ByVal Text As String, ParamArray Args() As Variant)
    WriteTextDirect(Text) = Args
End Sub