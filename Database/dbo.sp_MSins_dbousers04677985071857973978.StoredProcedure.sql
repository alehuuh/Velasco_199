USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_dbousers04677985071857973978]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_MSins_dbousers04677985071857973978]
		@c1 varchar(50),
		@c2 varchar(50),
		@c3 varchar(50)
	,@MSp2pPostVersion varbinary(32) 
as
begin  
begin try
	insert into [dbo].[users] (
		[userid],
		[username],
		[password],
		$sys_p2p_cd_id
	) values (
		@c1,
		@c2,
		@c3,
		@MSp2pPostVersion	) 
end try
begin catch
if @@error in (2627, 2601) 
begin  
	declare @cur_version varbinary(32) 
		,@conflict_type int = 5
		,@conflict_type_txt nvarchar(20) = N'Insert-Insert'
		,@reason_code int = 1
		,@reason_text nvarchar(720) = NULL
		,@is_on_disk_winner bit = 0
		,@is_incoming_winner bit = 0
		,@peer_id_current_node int = NULL
		,@peer_id_incoming int
		,@tranid_incoming nvarchar(40)
		,@peer_id_on_disk int
		,@tranid_on_disk nvarchar(40)
        ,@cur_version_text nvarchar(40) = NULL
        ,@MSp2pPreVersion_text nvarchar(40) = NULL
        ,@MSp2pPostVersion_text nvarchar(40) = convert(nvarchar(40), @MSp2pPostVersion, 1)
        ,@primarykey_text nvarchar(100) = ''
	select @peer_id_incoming = sys.fn_replvarbintoint(@MSp2pPostVersion)
		,@tranid_incoming = sys.fn_replp2pversiontotranid(@MSp2pPostVersion)
	select @cur_version = $sys_p2p_cd_id from [dbo].[users] 
	where [userid] = @c1
	if @@rowcount = 0  
			exec sys.sp_replrethrow
	else 
	begin  
		select @peer_id_on_disk = sys.fn_replvarbintoint(@cur_version)
			,@tranid_on_disk = sys.fn_replp2pversiontotranid(@cur_version)
		if(@peer_id_incoming > @peer_id_on_disk)
			set @is_incoming_winner = 1
		else
			set @is_on_disk_winner = 1
	end  
		select @peer_id_current_node = p.originator_id from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[users]') and p.options & 0x1 = 0x1
	if (@peer_id_current_node is not null) 
	begin 
		if (@reason_text is NULL)
			if (@is_incoming_winner = 1)
			begin  
				select @reason_text = formatmessage(22825,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
			else  
			begin  
				select @reason_text = formatmessage(22824,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
		create table #change_id (change_id varbinary(8))
		insert [dbo].[conflict_dbo_users] (
		[userid],
		[username],
		[password]
			,__$originator_id
			,__$origin_datasource
			,__$tranid
			,__$conflict_type
			,__$is_winner
			,__$reason_code
			,__$reason_text
			,__$update_bitmap
			,__$pre_version)
		output inserted.__$row_id into #change_id
		select 
		@c1,
		@c2,
		@c3			,@peer_id_current_node
			,@peer_id_incoming
			,@tranid_incoming
			,@conflict_type
			,@is_incoming_winner
			,@reason_code
			,@reason_text
			,NULL
			,NULL
		insert [dbo].[conflict_dbo_users] (

		[userid],
		[username],
		[password]			,__$originator_id
			,__$origin_datasource
			,__$tranid
			,__$conflict_type
			,__$is_winner
			,__$reason_code
			,__$reason_text
			,__$pre_version
			,__$change_id)
		select 

		[userid],
		[username],
		[password]			,@peer_id_current_node
			,@peer_id_on_disk
			,@tranid_on_disk
			,@conflict_type
			,@is_on_disk_winner
			,@reason_code
			,@reason_text
			,NULL
			,(select change_id from #change_id)
		from [dbo].[users] 

	where [userid] = @c1
	end 
	if(@is_incoming_winner = 1)
	begin  

update [dbo].[users] set
		[username] = @c2,
		[password] = @c3,
		$sys_p2p_cd_id = @MSp2pPostVersion
	where [userid] = @c1
	end  
		set @primarykey_text = @primarykey_text + '[userid] = ' + convert(nvarchar(100),@c1,1) + ', '
		set @cur_version_text = convert(nvarchar(40), @cur_version, 1) 
		if exists(select * from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[users]') and p.options & 0x10 = 0x10)
			raiserror(22815, 10, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[users]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
		else
			raiserror(22815, 16, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[users]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
end 
else  
	EXEC sys.sp_replrethrow
end catch 
end  
GO
