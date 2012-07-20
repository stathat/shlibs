<cfcomponent name="StatHat">

	<cfset this.statLimit = 255>

	<cffunction name="ezPostCount" access="public" returntype="void">

		<cfargument name="ezkey" required="true" type="string">
		<cfargument name="statName" required="true" type="string">
		<cfargument name="count" required="true" type="numeric">

		<cfset var data = "ezkey=" & URLEncodedFormat( arguments.ezkey ) & "&stat=" & URLEncodedFormat( Left( arguments.statName, this.statLimit ) ) & "&count=" & URLEncodedFormat( arguments.count )>

		<cftry>
			<cfhttp method="post" url="http://api.stathat.com/ez?#data#" charset="utf-8">

			<cfcatch>
				<cfoutput>ezPostCount exception: #cfcatch.message#</cfoutput>
			</cfcatch>
		</cftry>

		<cfreturn>
	</cffunction>

	<cffunction name="ezPostValue" access="public" returntype="void">

		<cfargument name="ezkey" required="true" type="string">
		<cfargument name="statName" required="true" type="string">
		<cfargument name="value" required="true" type="numeric">

		<cfset var data = "ezkey=" & URLEncodedFormat( arguments.ezkey ) & "&stat=" & URLEncodedFormat( Left( arguments.statName, this.statLimit ) ) & "&value=" & URLEncodedFormat( arguments.value )>

		<cftry>
			<cfhttp method="post" url="http://api.stathat.com/ez?#data#" charset="utf-8">

			<cfcatch>
				<cfoutput>ezPostValue exception: #cfcatch.message#</cfoutput>
			</cfcatch>
		</cftry>

		<cfreturn>
	</cffunction>

	<cffunction name="postCount" access="public" returntype="void">

		<cfargument name="ukey" required="true" type="string">
		<cfargument name="key" required="true" type="string">
		<cfargument name="count" required="true" type="numeric">

		<cfset var data = "ukey=" & URLEncodedFormat( arguments.ukey ) & "&key=" & URLEncodedFormat( arguments.key ) & "&count=" & URLEncodedFormat( arguments.count )>

		<cftry>
			<cfhttp method="post" url="http://api.stathat.com/c?#data#" charset="utf-8">

			<cfcatch>
				<cfoutput>postCount exception: #cfcatch.message#</cfoutput>
			</cfcatch>
		</cftry>

		<cfreturn>
	</cffunction>

	<cffunction name="postValue" access="public" returntype="void">

		<cfargument name="ukey" required="true" type="string">
		<cfargument name="key" required="true" type="string">
		<cfargument name="value" required="true" type="numeric">

		<cfset var data = "ukey=" & URLEncodedFormat( arguments.ukey ) & "&key=" & URLEncodedFormat( arguments.key ) & "&value=" & URLEncodedFormat( arguments.value )>

		<cftry>
			<cfhttp method="post" url="http://api.stathat.com/v?#data#" charset="utf-8">

			<cfcatch>
				<cfoutput>postValue exception: #cfcatch.message#</cfoutput>
			</cfcatch>
		</cftry>

		<cfreturn>
	</cffunction>

</cfcomponent>