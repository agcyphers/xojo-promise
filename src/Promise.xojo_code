#tag Class
Protected Class Promise
	#tag Method, Flags = &h21
		Private Sub Constructor(name as String = "")
		  self.Name = name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 437265617465732061206E65772050726F6D697365
		Shared Function Create(name as String = "") As Promise
		  '// If no name is supplied then we'll just randomly
		  '   create one. Duplicate names will delete the previous
		  '   task of the same name, cancelling its operation.
		  if name = "" then name = System.Random.InRange( 0, DateTime.Now.SecondsFrom1970 ).ToString
		  
		  return new Promise( name )
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub Error(instance as Promise)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Sub invokeError(target as Variant)
		  var job as Promise = Promise( target )
		  if job.DelegateError <> nil then job.DelegateError.Invoke( job )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub invokeResolved(target as Variant)
		  var job as Promise = Promise( target )
		  if job.DelegateResolved <> nil then job.DelegateResolved.Invoke( job )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C6C6261636B2066756E6374696F6E207768656E207468652050726F6D697365206661696C7320746F207265736F6C76652E
		Function OnError(callback as Error) As Promise
		  '// Set the property and return the instance to
		  '   support chaining because I'm being an overachiever.
		  
		  DelegateError = callback
		  
		  Return self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub onThreadRun(sender as Thread)
		  '// The meat of the Promise system.
		  '   Iterate all stored promises and check their status.
		  
		  var key as String
		  var job as Promise
		  
		  while jobs.KeyCount > 0
		    var max as Integer = jobs.KeyCount - 1
		    for index as Integer = 0 to max
		      
		      '// We don't worry about the exception as
		      '   these will happen in the natural course
		      '   of operation as we add and remove jobs.
		      #Pragma BreakOnExceptions Off
		      try
		        key = jobs.Key( index )
		        job = jobs.Value( key )
		      catch e as OutOfBoundsException
		        '// Once we hit the OOBE, we're outside the expected bounds
		        '   so just exit the For...Loop
		        exit
		      end try
		      #Pragma BreakOnExceptions Default
		      
		      '// Tell this job to perform its function.
		      if job.DelegateOperate <> nil then job.DelegateOperate.Invoke( job )
		      
		      '// Check to see if the job has reported a result.
		      var complete as Boolean = (job.Result <> nil or job.Error <> nil)
		      
		      if complete then
		        if job.Error <> nil and job.DelegateError <> nil then
		          '// The job reported an error, so we invoke the failure delegate.
		          timer.CallLater( 0, WeakAddressOf invokeError, job )
		        elseif job.Result <> nil and job.DelegateResolved <> nil then
		          '// The job reported success, invoke that delegate.
		          timer.CallLater( 0, WeakAddressOf invokeResolved, job )
		        end if
		        '// Remove the job from the queue.
		        jobs.Remove( key )
		      end if
		    next
		    
		    '// Give everything else time to operate before checking again.
		    sender.Sleep( Interval )
		  wend
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub Operate(instance as Promise)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0, Description = 5369676E616C73207468652050726F6D6973652073797374656D20746861742074686973207461736B2073686F756C6420626567696E2E
		Sub Resolve(callback as Operate)
		  '// We check for the existence of the thread
		  '   here so we can be sure that an instance
		  '   always exists in the shared space.
		  if jobThread = nil then
		    '// We need to keep one class instance around, so
		    '   we'll just create one.
		    controllerInstance = new Promise
		    
		    '// Setup the thread class instance
		    jobThread = new Thread
		    #if TargetAndroid then
		      jobThread.Type = Thread.Types.Cooperative
		    #else
		      jobThread.Type = thread.Types.Preemptive
		    #endif
		    AddHandler jobThread.Run, WeakAddressOf controllerInstance.onThreadRun
		    
		    '// Create our jobs queue.
		    jobs = new Dictionary
		  end if
		  
		  '// If a job with this name already exists, we'll
		  '   kill it. Jobs without a name supplied in the
		  '   Create method get a random name.
		  if jobs.HasKey( name ) then jobs.Remove( name )
		  
		  jobs.Value( name ) = self
		  
		  '// Set our Operate delegate, where the work for the promise
		  '   is performed.
		  DelegateOperate = callback
		  
		  '// We're ready to roll. Signal the thread.
		  if jobThread.ThreadState = Thread.ThreadStates.NotRunning then jobThread.Start
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resolve(callbackOperate as Operate, callbackResolved as Resolved, callbackError as Error = nil)
		  DelegateResolved = callbackResolved
		  DelegateError = callbackError
		  
		  Resolve( callbackOperate )
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub Resolved(instance as Promise)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0, Description = 43616C6C6261636B2064656C65676174652066756E6374696F6E207768656E207468652050726F6D697365207375636365737366756C6C79207265736F6C7665732E
		Function WhenResolved(callback as Resolved) As Promise
		  '// Set the property and return the instance to
		  '   support chaining because I'm being an overachiever.
		  DelegateResolved = callback
		  
		  Return self
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This class behaves as an engine for supporting
		promises in Xojo. There's a loop within a thread
		that performs each promise operation, and basically
		acts as a job pool.
		
	#tag EndNote

	#tag Note, Name = License
		MIT License
		
		Copyright (c) 2025 Anthony G. Cyphers
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private Shared controllerInstance As Promise
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DelegateError As Promise.Error
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DelegateOperate As Promise.Operate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DelegateResolved As Promise.Resolved
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5768656E207468652050726F6D69736520686173206572726F7265642C20746869732070726F7065727479206D757374206265206E6F6E2D4E696C2E
		Error As RuntimeException
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54696D652C20696E206D696C6C697365636F6E64732C20746F207969656C6420696E207468652050726F6D6973652073797374656D207461736B20697465726174696F6E2E
		Shared Interval As Integer = 100
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared jobs As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared jobThread As Thread
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 50726F6D697365207461736B206E616D652C2073686F756C6420626520756E69717565206F72206E65776572207461736B7320737570657263656465206F6C646572207461736B732E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 526573756C74206F66207468652070726F6D697365207375636365737366756C6C79207265736F6C76696E67
		Result As Variant
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 446576656C6F7065722073746F726167652E
		Tag As Variant
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
