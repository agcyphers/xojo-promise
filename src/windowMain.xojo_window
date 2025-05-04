#tag DesktopWindow
Begin DesktopWindow windowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1883547647
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Promise"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin DesktopButton buttonOne
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "One Job"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopListBox listResults
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   2
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   328
      Index           =   -2147483648
      InitialValue    =   "Job Name	Result"
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopButton buttonTen
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Ten Jobs"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   112
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopButton buttonSocketOne
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "One Socket"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   360
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   104
   End
   Begin DesktopButton buttonSocketTen
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Ten Sockets"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   476
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   104
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub addTaskRow(p as Promise, other as Variant = nil)
		  '// Create a ListBox row for the Promise
		  
		  listResults.AddRow( p.Name )
		  listResults.RowTagAt( listResults.LastAddedRowIndex ) = p
		  listResults.CellTagAt( listResults.LastAddedRowIndex, 0 ) = other
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onPromiseError(instance as Promise)
		  '// The promise failed
		  '   Completion delegates are called on the main thread.
		  OperationComplete( instance )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onPromiseOperate(instance as Promise)
		  '// In a real world application, you would check a variable or something
		  '   to determine if your async operation completed. This is just an example
		  '   showing operation, so we'll simulate everything.
		  
		  '// Simulate a wait time.
		  if (System.Random.InRange( 1, 5 ) > 2) then Return
		  
		  '// Simulate success or failure.
		  var isErrored as Boolean = (System.Random.InRange( 0, 1 ) = 1)
		  if isErrored then
		    '// Error. We set an Exception to the Error property.
		    var e as new RuntimeException
		    e.Message = "Failed"
		    instance.Error = e
		  else
		    '// Success. Set something to the Result property.
		    instance.Result = "Success"
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onPromiseResolved(instance as Promise)
		  '// The promise succeeded
		  '   Completion delegates are called on the main thread.
		  OperationComplete( instance )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onSocketComplete(sender as PromisedURLConnection, result as String, isError as Boolean)
		  '// The promise resolved, either with success or error.
		  '   Report the results to the UI.
		  var max as Integer = listResults.LastRowIndex
		  for index as Integer = 0 to max
		    if listResults.CellTagAt( index, 0 ) = sender then
		      listResults.CellTextAt( index, 1 ) = result
		      listResults.RowTagAt( index ) = nil
		    end if
		  next
		  
		  listResults.ScrollPosition = listResults.LastRowIndex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OperationComplete(sender as Variant)
		  '// The promise resolved, either with success or error.
		  '   Report the results to the UI.
		  var p as Promise = Promise( sender )
		  
		  var result as String = p.Result.StringValue
		  if p.Error <> nil then result = p.Error.Message
		  
		  var max as Integer = listResults.LastRowIndex
		  for index as Integer = 0 to max
		    if listResults.RowTagAt( index ) = sender then
		      listResults.CellTextAt( index, 1 ) = result
		      listResults.RowTagAt( index ) = nil
		    end if
		  next
		  
		  listResults.ScrollPosition = listResults.LastRowIndex
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events buttonOne
	#tag Event
		Sub Pressed()
		  '// Create a new Promise. Supports chaining.
		  var p as Promise = Promise.Create( "Job" )
		  p.OnError( WeakAddressOf onPromiseError ).WhenResolved( WeakAddressOf onPromiseResolved ).Resolve( WeakAddressOf onPromiseOperate )
		  
		  '// Add the promise row to the listbox.
		  addTaskRow( p )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events buttonTen
	#tag Event
		Sub Pressed()
		  '// Create 10 promises to resolve.
		  
		  for index as Integer = 0 to 9
		    '// Create a new Promise. Supports chaining.
		    var p as Promise = Promise.Create
		    p.OnError( WeakAddressOf onPromiseError ).WhenResolved( WeakAddressOf onPromiseResolved ).Resolve( WeakAddressOf onPromiseOperate )
		    
		    '// Add the promise row to the listbox.
		    addTaskRow( p )
		  next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events buttonSocketOne
	#tag Event
		Sub Pressed()
		  var urlSocket as new PromisedURLConnection( "Socket" )
		  AddHandler urlSocket.Complete, WeakAddressOf onSocketComplete
		  
		  urlSocket.GetData( "https://example.com/" )
		  
		  addTaskRow( urlSocket.promise, urlSocket )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events buttonSocketTen
	#tag Event
		Sub Pressed()
		  for index as Integer = 0 to 9
		    var urlSocket as new PromisedURLConnection
		    AddHandler urlSocket.Complete, WeakAddressOf onSocketComplete
		    
		    urlSocket.GetData( "https://example.com/" )
		    
		    addTaskRow( urlSocket.promise, urlSocket )
		  next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
