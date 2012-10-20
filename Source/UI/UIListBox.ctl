VERSION 5.00
Begin VB.UserControl UIListBox 
   BackColor       =   &H80000005&
   ClientHeight    =   2385
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2460
   ScaleHeight     =   2385
   ScaleWidth      =   2460
End
Attribute VB_Name = "UIListBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'    CopyRight (c) 2008 Kelly Ethridge
'
'    This file is part of SimplyVBUnitUI.
'
'    SimplyVBUnitUI is free software; you can redistribute it and/or modify
'    it under the terms of the GNU Library General Public License as published by
'    the Free Software Foundation; either version 2.1 of the License, or
'    (at your option) any later version.
'
'    SimplyVBUnitUI is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU Library General Public License for more details.
'
'    You should have received a copy of the GNU Library General Public License
'    along with Foobar; if not, write to the Free Software
'    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'    Module: UIListBox
'

Option Explicit
Implements ISuperClass

Private Const SIZEOF_MEASUREITEMSTRUCTURE   As Long = 24
Private Const SIZEOF_DRAWITEMSTRUCTURE      As Long = 48


Private mLBHwnd         As Long
Private mSuper          As New SuperClass
Private mWidest         As Long
Private mFontHandle     As Long
Private mMeasureItem()  As MEASUREITEMSTRUCT
Private mMeasureItemSA  As SafeArray1d
Private mDrawItem()     As DRAWITEMSTRUCT
Private mDrawItemSA     As SafeArray1d



Public Sub AddItem(ByVal Value As String)
    Call SendMessage(mLBHwnd, LB_ADDSTRING, 0, ByVal Value)
End Sub

Public Property Get ListCount() As Long
    ListCount = SendMessage(mLBHwnd, LB_GETCOUNT, 0, ByVal 0&)
End Property

Public Property Get Font() As Font
    Set Font = UserControl.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
    Set UserControl.Font = New_Font
    Call DeleteObject(mFontHandle)
    mFontHandle = vbNullPtr
    Call PropertyChanged("Font")
End Property

Public Sub Clear()
    Call SendMessage(mLBHwnd, LB_RESETCONTENT, 0, ByVal 0&)
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   Private Methods
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function GetItem(ByVal Index As Long) As String
    Dim Result As String
    
    Result = String$(SendMessage(mLBHwnd, LB_GETTEXTLEN, Index, ByVal 0&), 0)
    Call SendMessage(mLBHwnd, LB_GETTEXT, Index, ByVal Result)
    
    GetItem = Result
End Function

Private Sub FillMeasureItem(ByRef Measurement As MEASUREITEMSTRUCT)
    Dim Item As String
    Item = GetItem(Measurement.itemID)

    Measurement.itemHeight = UserControl.TextHeight(Item) \ Screen.TwipsPerPixelY
    Measurement.itemWidth = UserControl.TextWidth(Item) \ Screen.TwipsPerPixelX
    
    If Measurement.itemWidth > mWidest Then
        Call SendMessage(mLBHwnd, LB_SETHORIZONTALEXTENT, Measurement.itemWidth + 50, 0)
        mWidest = Measurement.itemWidth
    End If
End Sub

Private Sub DrawItem(ByRef Canvas As DRAWITEMSTRUCT)
    Call InitFont(Canvas)
    
    Dim Item As String
    Item = GetItem(Canvas.itemID)
    
    Dim SystemBrushColor    As Long
    Dim BackgroundColor     As Long
    Dim TextColor           As Long
    
    If (Canvas.itemState And ODS_SELECTED) = ODS_SELECTED Then
        SystemBrushColor = vbHighlight And &HF
        BackgroundColor = vbHighlight And &HF
        TextColor = vbHighlightText And &HF
    Else
        SystemBrushColor = vbWindowBackground And &HF
        BackgroundColor = vbWindowBackground And &HF
        TextColor = vbWindowText And &HF
    End If
    
    Call FillRect(Canvas.hdc, Canvas.rcItem, GetSysColorBrush(SystemBrushColor))
    Call SetBkColor(Canvas.hdc, GetSysColor(BackgroundColor))
    Call SetTextColor(Canvas.hdc, GetSysColor(TextColor))
    
    Dim OldFont As Long
    OldFont = SelectObject(Canvas.hdc, mFontHandle)
    Call DrawText(Canvas.hdc, Item, Len(Item), Canvas.rcItem, DT_LEFT)
    Call SelectObject(Canvas.hdc, OldFont)
End Sub

Private Sub InitFont(ByRef Canvas As DRAWITEMSTRUCT)
    If mFontHandle = vbNullPtr Then
        Dim LF As LOGFONT
        With UserControl.Font
            LF.lfCharSet = .Charset
            LF.lfHeight = -(.Size * GetDeviceCaps(Canvas.hdc, LOGPIXELSY) / 72)
            LF.lfWeight = .Weight
            LF.lfUnderline = .Underline
            LF.lfFaceName = .Name & vbNullChar
        End With
        
        mFontHandle = CreateFontIndirect(LF)
    End If
End Sub

Private Sub InitArrays()
    With mMeasureItemSA
        .cbElements = SIZEOF_MEASUREITEMSTRUCTURE
        .cDims = 1
        .cElements = 1
    End With
    
    With mDrawItemSA
        .cbElements = SIZEOF_DRAWITEMSTRUCTURE
        .cDims = 1
        .cElements = 1
    End With
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   ISuperClass Interface
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub ISuperClass_After(lReturn As Long, ByVal hWnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
    Select Case uMsg
        Case WM_MEASUREITEM
            Call SetSAPtr(mMeasureItem, VarPtr(mMeasureItemSA))
            mMeasureItemSA.pvData = lParam
            Call FillMeasureItem(mMeasureItem(0))
            Call SetSAPtr(mMeasureItem, vbNullPtr)
            lReturn = BOOL_TRUE

        Case WM_DRAWITEM
            Call SetSAPtr(mDrawItem, VarPtr(mDrawItemSA))
            mDrawItemSA.pvData = lParam
            Call DrawItem(mDrawItem(0))
            Call SetSAPtr(mDrawItem, vbNullPtr)
            lReturn = BOOL_TRUE
            
    End Select
End Sub

Private Sub ISuperClass_Before(lHandled As Long, lReturn As Long, ByVal hWnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   UserControl Events
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub UserControl_Initialize()
    mLBHwnd = CreateWindowEx(WS_EX_OVERLAPPEDWINDOW, "LISTBOX", vbNullString, LBS_OWNERDRAWVARIABLE Or LBS_HASSTRINGS Or WS_CHILD Or WS_VISIBLE Or WS_VSCROLL Or WS_HSCROLL, 0, 0, UserControl.Width \ Screen.TwipsPerPixelX, UserControl.Height \ Screen.TwipsPerPixelY, UserControl.hWnd, 0, 0, ByVal 0&)
    
    If mLBHwnd = vbNullPtr Then _
        Call Err.Raise(errorCode.InvalidOperation, "UIListBox.Initialize", "Could not create listbox window.")
    
    Call InitArrays
    Call mSuper.AddMsg(WM_MEASUREITEM)
    Call mSuper.AddMsg(WM_DRAWITEM)
    Call mSuper.Subclass(UserControl.hWnd, Me)
End Sub

Private Sub UserControl_Terminate()
    Call DeleteObject(mFontHandle)
End Sub

Private Sub UserControl_InitProperties()
    Set UserControl.Font = Ambient.Font
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    Set UserControl.Font = PropBag.ReadProperty("Font", Ambient.Font)
End Sub

Private Sub UserControl_Resize()
    Call SetWindowPos(mLBHwnd, 0, 0, 0, UserControl.Width \ Screen.TwipsPerPixelX, UserControl.Height \ Screen.TwipsPerPixelY, 0)
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("Font", UserControl.Font, Ambient.Font)
End Sub


