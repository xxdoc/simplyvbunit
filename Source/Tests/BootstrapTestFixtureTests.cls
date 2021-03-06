VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BootstrapTestFixtureTests"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Copyright 2009 Kelly Ethridge
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
' Module: BootstrapTestFixtureTests
'
Option Explicit
Implements IBootstrapTestClass

Private mCount As Long

Public Function Run() As Long
    mCount = 0
    
    RunTest Constructor_WithEmptyTestClass_Creates0TestCases
    RunTest Constructor_WithClassWithOneTest_Creates1TestCase
    RunTest Constructor_WithClassWithProperty_ExcludesPropertyAsTest
    RunTest Run_UsingClassWithOneTest_ExecutesTest
    
    Run = mCount
End Function

Private Sub RunTest(ByRef v As Variant)
    mCount = mCount + 1
End Sub

Private Function Constructor_WithEmptyTestClass_Creates0TestCases()
    Dim TestClass As New FakeEmpty
    Dim Fixture As TestFixture
    
    Set Fixture = Sim.NewTestFixture(TestClass)
    
    Dim Actual As Long
    Actual = Fixture.TestCount
    Debug.Assert Actual = 0
End Function

Private Function Constructor_WithClassWithOneTest_Creates1TestCase()
    Dim TestClass As New Fake1Test
    Dim Fixture As TestFixture
    
    Set Fixture = Sim.NewTestFixture(TestClass)
    
    Dim Actual As Long
    Actual = Fixture.TestCount
    Debug.Assert Actual = 1
End Function

Private Function Constructor_WithClassWithProperty_ExcludesPropertyAsTest()
    Dim TestClass As New Fake1Property
    Dim Fixture As TestFixture
    
    Set Fixture = Sim.NewTestFixture(TestClass)
    
    Dim Actual As Long
    Actual = Fixture.TestCount
    Debug.Assert Actual = 0
End Function

Private Function Run_UsingClassWithOneTest_ExecutesTest()
    Dim TestClass As New Mock1Test
    Dim Fixture As TestFixture
    Set Fixture = Sim.NewTestFixture(TestClass)

    Fixture.Run

    Dim Actual As Long
    Actual = TestClass.Calls.Count
    Debug.Assert Actual = 1
End Function





Private Function IBootstrapTestClass_Run() As Long
    IBootstrapTestClass_Run = Run
End Function
