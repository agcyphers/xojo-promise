#tag Class
Protected Class PromisedURLConnection
	#tag Method, Flags = &h0
		Sub Constructor(name as String = "")
		  self.Name = name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetData(URL as String)
		  self.url = url
		  
		  self.promise = Promise.Create( Name )
		  self.promise.OnError( WeakAddressOf onPromiseError ).WhenResolved( WeakAddressOf onPromiseResolved ).Resolve( WeakAddressOf onPromiseOperate )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onPromiseError(instance as Promise)
		  OperationComplete( instance )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onPromiseOperate(instance as Promise)
		  if socket = nil then
		    '// Socket will always be Nil the first time, regardless of target
		    socket = new URLConnection
		    
		    #if TargetAndroid then
		      '// We want Android to be async so that the result is checked
		      '   by the Promise system periodically.
		      AddHandler socket.DataReceived, WeakAddressOf onSocketDataReceived
		      
		      socket.Send( "GET", url )
		    #else
		      '// Otherwise, we just grab the data and set the result to tell
		      '   the Promise system that the task is complete.
		      try
		        instance.result = socket.SendSync( "GET", url )
		      catch e as NetworkException
		        instance.Error = e
		      end try
		      
		      Return
		    #endif
		  end if
		  
		  #if TargetAndroid then
		    '// Check the result to determine if the job is complete.
		    if socket.HTTPStatusCode = 200 then '// Complete with result
		      instance.Result = result
		    ElseIf socket.HTTPStatusCode > 0 then '// Complete with failue
		      var e as new NetworkException
		      e.Message = "Failed."
		      e.ErrorNumber = socket.HTTPStatusCode
		      instance.Error = e
		    else
		      '// Incomplete. Do nothing
		    end if
		  #else
		    '// Should, really, never get here.
		    Break
		  #endif
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
		Private Sub onSocketDataReceived(sender as URLConnection, URL as String, HTTPStatus as Integer, content as String)
		  result = content
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OperationComplete(sender as Variant)
		  '// The promise resolved, either with success or error.
		  '   Report the results to the UI.
		  var p as Promise = Promise( sender )
		  
		  var result as String = p.Result.StringValue
		  var isError as Boolean = False
		  if p.Error <> nil then
		    result = p.Error.Message
		    isError = True
		  end if
		  
		  RaiseEvent Complete( result, isError )
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Complete(result as String, isError as Boolean)
	#tag EndHook


	#tag Note, Name = About
		This is simply an example that loads data from a URL
		asynchronously on Android and synchronously everywhere else.
		
	#tag EndNote


	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		promise As Promise
	#tag EndProperty

	#tag Property, Flags = &h21
		Private result As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private socket As URLConnection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private url As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
