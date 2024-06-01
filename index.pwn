/*
	Credit:
	- Salim (Contact me: Salim#5857)
	//if u remove this, u nerd.
*/
#include <string>
#include <foreach>
#include <discord-connector>//you need to install this plugin
#include <discord-cmd>

//bot tictactoe
#define MAX_TTT_PLAY        5

enum TicTacToeStruct
{
	ChannelID[30],
	bool:Play,
	Giliran,
	Player1ID[30],
	Player2ID[30],
	MarkNumber[9],
}
new tttData[MAX_TTT_PLAY][TicTacToeStruct],
	Iterator:TicTacToe<MAX_TTT_PLAY>;
	
ResetTicTacToeData(id)
{
    format(tttData[id][ChannelID], 30, "-");
    tttData[id][Play] = false;
    format(tttData[id][Player1ID], 30, "-");
    format(tttData[id][Player2ID], 30, "-");
    tttData[id][Giliran] = 0;
    
    for(new i = 0; i < 9; i++)
    {
    	tttData[id][MarkNumber][i] = 0;
    }
}

DCMD:cancel(user, channel, params[])
{
    new userid[DCC_ID_SIZE], channelid[DCC_ID_SIZE];

    DCC_GetUserId(user, userid);
	DCC_GetChannelId(channel, channelid);
	
    foreach(new id : TicTacToe)
    {
    	if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
		{
			if(!strcmp(tttData[id][Player1ID], userid, true, 30) || !strcmp(tttData[id][Player2ID], userid, true, 30))
 			{
			    Iter_Remove(TicTacToe, id);
				ResetTicTacToeData(id);
				SendInfoEmbed(channel, "Permainan dibatalkan");
			}
		}
	}
	return 1;
}

DCMD:tictactoe(user, channel, params[])
{
	new playerid[30], playerids[DCC_ID_SIZE], DCC_User:otherid, channelid[DCC_ID_SIZE];
	if(sscanf(params, "s[30]", playerid)) return SendErrorEmbed(channel, "USAGE: /tictactoe [user id]");
	if(!IsNumeric(playerid)) return SendErrorEmbed(channel, "USAGE: /tictactoe [user id]");
	otherid = DCC_FindUserById(playerid);
	DCC_GetUserId(user, playerids);
	if(!strcmp(playerids, playerid, true, 30)) return SendErrorEmbed(channel, "Anda tidak dapat bermain dengan diri anda sendiri");
	DCC_GetChannelId(channel, channelid);
	
	new id = Iter_Free(TicTacToe);
	if(id == -1) return SendErrorEmbed(channel, "Anda sementara tidak bisa bermain.");
	foreach(new i : TicTacToe)
	{
	    if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
	    {
	        return SendErrorEmbed(channel, "Permainan seseorang di channel ini belum selesai.");
	    }
	    if(!strcmp(tttData[id][Player1ID], playerids, true, 30) || !strcmp(tttData[id][Player2ID], playerids, true, 30))
	    {
	        return SendErrorEmbed(channel, "Tolong selesaikan permainan anda terlebih dulu, gunakan **/cancel** untuk membatalkan permainan.");
	    }
	}
	
	Iter_Add(TicTacToe, id);
	ResetTicTacToeData(id);
	//---
	format(tttData[id][ChannelID], 30, channelid);
    tttData[id][Play] = false;
    format(tttData[id][Player1ID], 30, playerids);
    format(tttData[id][Player2ID], 30, playerid);
    tttData[id][Giliran] = 1;
    //---
    new name[DCC_USERNAME_SIZE], name2[DCC_USERNAME_SIZE];
    DCC_GetUserName(user, name);
    DCC_GetUserName(otherid, name2);
    
    printf("%s menantang tic tac toe kepada %s", name, name2);
    
    new string[200];
    format(string, sizeof string, "**%s**, **%s** telah menantang anda untuk bermain tic tac toe. (Y/N)", name2, name);
    SendInfoEmbed(channel, string);
    
	return 1;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
	new
		DCC_User:user,
		DCC_Channel:channel,
		cmdtext[DCMD_TOTAL_CMD_SIZE],
		userid[DCC_ID_SIZE],
		channelid[DCC_ID_SIZE],
		bool:isBot;

    DCC_GetMessageAuthor(message, user);
    DCC_GetUserId(user, userid);
	DCC_GetMessageChannel(message, channel);
	DCC_GetChannelId(channel, channelid);
	DCC_IsUserBot(user, isBot);
		
	DCC_GetMessageContent(message, cmdtext, sizeof(cmdtext));//MarkNumberTTT(id, player, DCC_Channel:channel, num);
	
	if(!strcmp(cmdtext, "1", true, 10))
	{
        if(isBot) return 0;
        
        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "2", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "3", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "4", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "5", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "6", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "7", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "8", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "9", true, 10))
	{
        if(isBot) return 0;

        new num = strval(cmdtext);

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
			{
		        if(tttData[id][Play] == true)
				{
				    if(!strcmp(tttData[id][Player1ID], userid, true, 30))
		    		{
				        if(tttData[id][Giliran] == 1)
				        {
					        MarkNumberTTT(id, 1, channel, num);
						}
				    }
					if(!strcmp(tttData[id][Player2ID], userid, true, 30))
					{
				        if(tttData[id][Giliran] == 2)
				        {
					        MarkNumberTTT(id, 2, channel, num);
						}
				    }
				}
			}
        }
	}
	if(!strcmp(cmdtext, "Y", true, 10))
	{
        if(isBot) return 0;
        
        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][Player2ID], userid, true, 30))
		    {
				if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
				{
				    if(tttData[id][Play] == false)
				    {
				        tttData[id][Play] = true;
				        MarkNumberTTT(id, 2, channel, 0);
				        SendInfoEmbed(channel, "Anda menerima tantangan permainan tic tac toe");
				    }
				}
			}
        }
	}
	else if(!strcmp(cmdtext, "N", true, 10))
	{
        if(isBot) return 0;

        foreach(new id : TicTacToe)
        {
            if(!strcmp(tttData[id][Player2ID], userid, true, 30))
		    {
				if(!strcmp(tttData[id][ChannelID], channelid, true, 30))
				{
				    if(tttData[id][Play] == false)
				    {
				        Iter_Remove(TicTacToe, id);
						ResetTicTacToeData(id);
				        SendInfoEmbed(channel, "Anda menolak tantangan permainan tic tac toe");
				    }
				}
			}
        }
	}
	return 1;
}

GetPlayerWinName(id)
{
    new DCC_User:user1 = DCC_FindUserById(tttData[id][Player1ID]);
	new DCC_User:user2 = DCC_FindUserById(tttData[id][Player2ID]);
	new name1[DCC_USERNAME_SIZE], name2[DCC_USERNAME_SIZE], name[50];
    DCC_GetUserName(user1, name1);
    DCC_GetUserName(user2, name2);
    
    if(tttData[id][MarkNumber][0] == 1 && tttData[id][MarkNumber][1] == 1 && tttData[id][MarkNumber][2] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][3] == 1 && tttData[id][MarkNumber][4] == 1 && tttData[id][MarkNumber][5] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][6] == 1 && tttData[id][MarkNumber][7] == 1 && tttData[id][MarkNumber][8] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][0] == 1 && tttData[id][MarkNumber][3] == 1 && tttData[id][MarkNumber][6] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][1] == 1 && tttData[id][MarkNumber][4] == 1 && tttData[id][MarkNumber][7] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][2] == 1 && tttData[id][MarkNumber][5] == 1 && tttData[id][MarkNumber][8] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][0] == 1 && tttData[id][MarkNumber][4] == 1 && tttData[id][MarkNumber][8] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][6] == 1 && tttData[id][MarkNumber][4] == 1 && tttData[id][MarkNumber][2] == 1)
    {
        name = name1;
    }
    else if(tttData[id][MarkNumber][0] == 2 && tttData[id][MarkNumber][1] == 2 && tttData[id][MarkNumber][2] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][3] == 2 && tttData[id][MarkNumber][4] == 2 && tttData[id][MarkNumber][5] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][6] == 2 && tttData[id][MarkNumber][7] == 2 && tttData[id][MarkNumber][8] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][0] == 2 && tttData[id][MarkNumber][3] == 2 && tttData[id][MarkNumber][6] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][1] == 2 && tttData[id][MarkNumber][4] == 2 && tttData[id][MarkNumber][7] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][2] == 2 && tttData[id][MarkNumber][5] == 2 && tttData[id][MarkNumber][8] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][0] == 2 && tttData[id][MarkNumber][4] == 2 && tttData[id][MarkNumber][8] == 2)
    {
        name = name2;
    }
    else if(tttData[id][MarkNumber][6] == 2 && tttData[id][MarkNumber][4] == 2 && tttData[id][MarkNumber][2] == 2)
    {
        name = name2;
    }
    else
    {
        name = "Seri";
    }
    return name;
}

MarkNumberTTT(id, player, DCC_Channel:channel, num)
{
	if(0 >= num > 9) return 1;
	if(0 >= player > 2) return 1;
	if(!Iter_Contains(TicTacToe, id)) return 1;

    if(0 < num <= 9)
    {
		tttData[id][MarkNumber][num-1] = player;
	}
	//---
	new string[200], count, siapa[50];
	
	format(siapa, sizeof siapa, "%s", GetPlayerWinName(id));
	
	if(!strcmp(siapa, "Seri", true, 5))
	{
		for(new i=0; i<9; i++)
		{
		    if(tttData[id][MarkNumber][i] != 0)
		    {
		        count++;
		    }
		}
		if(count>=9)
		{
		    format(string, sizeof string, "Permainan berakhir seri\n\n");
		    SetTimerEx("ResetTTT", 1000, false, "i", id);
		}
	}

	if(tttData[id][MarkNumber][0] != 0)//1
	{
	    if(tttData[id][MarkNumber][0] == 1)
	    {
	        format(string, sizeof string, "%s:x:", string);
	    }
	    else if(tttData[id][MarkNumber][0] == 2)
	    {
	        format(string, sizeof string, "%s:o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s:one:", string);
	}
	if(tttData[id][MarkNumber][1] != 0)//2
	{
	    if(tttData[id][MarkNumber][1] == 1)
	    {
	        format(string, sizeof string, "%s :x:", string);
	    }
	    else if(tttData[id][MarkNumber][1] == 2)
	    {
	        format(string, sizeof string, "%s :o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :two:", string);
	}
	if(tttData[id][MarkNumber][2] != 0)//3
	{
	    if(tttData[id][MarkNumber][2] == 1)
	    {
	        format(string, sizeof string, "%s :x:\n", string);
	    }
	    else if(tttData[id][MarkNumber][2] == 2)
	    {
	        format(string, sizeof string, "%s :o:\n", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :three:\n", string);
	}
	if(tttData[id][MarkNumber][3] != 0)//4
	{
	    if(tttData[id][MarkNumber][3] == 1)
	    {
	        format(string, sizeof string, "%s:x:", string);
	    }
	    else if(tttData[id][MarkNumber][3] == 2)
	    {
	        format(string, sizeof string, "%s:o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s:four:", string);
	}
	if(tttData[id][MarkNumber][4] != 0)//5
	{
	    if(tttData[id][MarkNumber][4] == 1)
	    {
	        format(string, sizeof string, "%s :x:", string);
	    }
	    else if(tttData[id][MarkNumber][4] == 2)
	    {
	        format(string, sizeof string, "%s :o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :five:", string);
	}
	if(tttData[id][MarkNumber][5] != 0)//6
	{
	    if(tttData[id][MarkNumber][5] == 1)
	    {
	        format(string, sizeof string, "%s :x:\n", string);
	    }
	    else if(tttData[id][MarkNumber][5] == 2)
	    {
	        format(string, sizeof string, "%s :o:\n", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :six:\n", string);
	}
	if(tttData[id][MarkNumber][6] != 0)//7
	{
	    if(tttData[id][MarkNumber][6] == 1)
	    {
	        format(string, sizeof string, "%s:x:", string);
	    }
	    else if(tttData[id][MarkNumber][6] == 2)
	    {
	        format(string, sizeof string, "%s:o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s:seven:", string);
	}
	if(tttData[id][MarkNumber][7] != 0)//8
	{
	    if(tttData[id][MarkNumber][7] == 1)
	    {
	        format(string, sizeof string, "%s :x:", string);
	    }
	    else if(tttData[id][MarkNumber][7] == 2)
	    {
	        format(string, sizeof string, "%s :o:", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :eight:", string);
	}
	if(tttData[id][MarkNumber][8] != 0)//9
	{
	    if(tttData[id][MarkNumber][8] == 1)
	    {
	        format(string, sizeof string, "%s :x:\n\n", string);
	    }
	    else if(tttData[id][MarkNumber][8] == 2)
	    {
	        format(string, sizeof string, "%s :o:\n\n", string);
	    }
	}
	else
	{
	    format(string, sizeof string, "%s :nine:\n\n", string);
	}
	
	new DCC_User:user1 = DCC_FindUserById(tttData[id][Player1ID]);
	new DCC_User:user2 = DCC_FindUserById(tttData[id][Player2ID]);
	new name1[DCC_USERNAME_SIZE], name2[DCC_USERNAME_SIZE];
    DCC_GetUserName(user1, name1);
    DCC_GetUserName(user2, name2);
    
    if(player == 1)
    {
        format(string, sizeof string, "%sSekarang giliran **%s**", string, name2);
        tttData[id][Giliran] = 2;
    }
    else if(player == 2)
    {
        format(string, sizeof string, "%sSekarang giliran **%s**", string, name1);
        tttData[id][Giliran] = 1;
    }
    else
    {
        format(string, sizeof string, "%sUntuk bermain kembali ketik **'/tictactoe'**.", string);
    }
    if(strcmp(siapa, "Seri", true, 5))
	{
		Iter_Remove(TicTacToe, id);
		ResetTicTacToeData(id);
	    format(string, sizeof string, "%s__**%s** memenangkan permainan__\n\n", string, siapa);
	}
	DCC_SendChannelMessage(channel, string);
	
 	return 1;
}

function ResetTTT(id)
{
    Iter_Remove(TicTacToe, id);
	ResetTicTacToeData(id);
	return 1;
}
