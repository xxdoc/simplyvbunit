VERSION 5.00
Begin VB.Form frmOptions 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "SimplyVBUnit Options"
   ClientHeight    =   3720
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6510
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3720
   ScaleWidth      =   6510
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkAllowStop 
      Caption         =   "Allow tests to be stopped"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   9
      ToolTipText     =   "Allowing tests to be stopped will slow down the test run."
      Top             =   1200
      Width           =   2655
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4080
      TabIndex        =   8
      Top             =   3240
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5280
      TabIndex        =   7
      Top             =   3240
      Width           =   1095
   End
   Begin VB.CheckBox chkAutoRunTests 
      Caption         =   "Autorun tests on start"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   5
      Top             =   840
      Width           =   2655
   End
   Begin VB.CheckBox chkOutputToLogConsole 
      Caption         =   "Output to log console"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   4
      Top             =   2160
      Width           =   3615
   End
   Begin VB.CheckBox chkOutputToErrorConsole 
      Caption         =   "Output to error console"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   3
      Top             =   2520
      Width           =   3615
   End
   Begin VB.CheckBox chkOutputToTextConsole 
      Caption         =   "Output to text console"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   2
      Top             =   1800
      Width           =   3615
   End
   Begin VB.ComboBox cboTreeViewStates 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      ItemData        =   "frmOptions.frx":0000
      Left            =   3960
      List            =   "frmOptions.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   360
      Width           =   1455
   End
   Begin VB.Label Label2 
      BorderStyle     =   1  'Fixed Single
      Height          =   45
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   6255
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Test TreeView state when starting test:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   210
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   3360
   End
End
Attribute VB_Name = "frmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mOK         As Boolean
Private mOptions    As UIConfiguration

Public Function Edit(ByVal Options As UIConfiguration, ByVal Owner As Object) As Boolean
    Set mOptions = Options
    Call DisplayOptions
    Call Me.Show(vbModal, Owner)

    Edit = mOK
End Function

Private Sub DisplayOptions()
    Me.cboTreeViewStates.Text = mOptions.TreeViewStartUpState

    Call SetChecked(Me.chkAutoRunTests, mOptions.AutoRun)
    Call SetChecked(Me.chkAllowStop, mOptions.AllowStop)
    Call SetChecked(Me.chkOutputToErrorConsole, mOptions.OutputToErrorConsole)
    Call SetChecked(Me.chkOutputToLogConsole, mOptions.OutputToLogConsole)
    Call SetChecked(Me.chkOutputToTextConsole, mOptions.OutputToTextConsole)
End Sub

Private Sub cmdCancel_Click()
    Call Unload(Me)
End Sub

Private Sub cmdOK_Click()
    mOptions.TreeViewStartUpState = Me.cboTreeViewStates.Text
    mOptions.AutoRun = GetChecked(Me.chkAutoRunTests)
    mOptions.AllowStop = GetChecked(Me.chkAllowStop)
    mOptions.OutputToErrorConsole = GetChecked(Me.chkOutputToErrorConsole)
    mOptions.OutputToLogConsole = GetChecked(Me.chkOutputToLogConsole)
    mOptions.OutputToTextConsole = GetChecked(Me.chkOutputToTextConsole)
    
    mOK = True
    Call Unload(Me)
End Sub

Private Function ToCheckMark(ByVal Condition As Boolean) As CheckBoxConstants
    If Condition Then
        ToCheckMark = vbChecked
    Else
        ToCheckMark = vbUnchecked
    End If
End Function

Private Function GetChecked(ByVal CheckBox As CheckBox) As Boolean
    GetChecked = (CheckBox.Value = vbChecked)
End Function

Private Sub SetChecked(ByVal CheckBox As CheckBox, ByVal Checked As Boolean)
    If Checked Then
        CheckBox.Value = vbChecked
    Else
        CheckBox.Value = vbUnchecked
    End If
End Sub
