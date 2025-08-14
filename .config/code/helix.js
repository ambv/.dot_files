/**
 * Keybindings for helix editor
 */

// add count argument
function repeatable(command) {
	return {
		command,
		count: "_ctx.count"
	};
}

// record command to a register
function record(command, reg) {
	return {
		command,
		record: reg
	};
}

// reset previous selections but keep all cursors
function reselect(command) {
	return [
		"modalEditor.clearSelections",
		command
	];
}

// record change
const recordChange = command => record(command, "change");
// record motion
const recordMotion = command => record(command, "motion");

function gotoLineOrCommand() {
	let result = {
    	"\n": "workbench.action.showCommands",
	}
	for (let i = 1; i <= 9; i++) {
		result[i] = {
			"command": "workbench.action.quickOpen",
			"args": ':' + i.toString(),
		}
	}
	for (let letter of "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") {
		result[letter] = {
			"command": "workbench.action.quickOpen",
			"args": '>' + letter,
        }
	}
	return result;
}

module.exports = {
	// Common keybindings (except for insert mode)
	"": {
		u: repeatable("undo"),
		U: repeatable("redo"),
		/* Multi-cursor
		 * (for insert cursor above, use keybindings.json for Alt-Shift-C)
		 */
		C: repeatable("editor.action.insertCursorBelow"),
		",": "removeSecondaryCursors",
		";": "modalEditor.clearSelections",

		J: repeatable("editor.action.joinLines"),
		"\n": repeatable("modalEditor.selectLine"),
		"<": repeatable("editor.action.outdentLines"),
		">": repeatable("editor.action.indentLines"),
		y: [
			"modalEditor.yank",
			"modalEditor.setNormalMode",
			"settings.cycle.gitblameOn"
		],
		x: [
			"modalEditor.cut",
			"modalEditor.setNormalMode",
			"settings.cycle.gitblameOn"
		],
		d: [
			"modalEditor.delete",
			"modalEditor.setNormalMode",
			"settings.cycle.gitblameOn"
		],
		p: repeatable("modalEditor.paste"),
		P: repeatable({
			command: "modalEditor.paste",
			args: {
				before: true
			}
		}),
		R: [
			"modalEditor.delete",
			{
				command: "modalEditor.paste",
				args: {
					before: true
				}
			}
		],
		"`": "modalEditor.toLowerCase",
		"~": "modalEditor.toUpperCase",
		// Replace selections
		r: {
			// Wildcard character
			"": {
				command: "modalEditor.transform",
				// use a js expression for computed args
				computedArgs: true,
				// replace with last key in the key sequence
				args: `{
					transformer: text => _ctx.keys.charAt(_ctx.keys.length-1).repeat(text.length)
				}`
			}
		},
	
		// into command mode
		// ":": "modalEditor.setCommandMode",
        ":": gotoLineOrCommand(),
		
		// replay last change
		".": {
			command: "modalEditor.replayRecord",
			args: "change"
		},

		// Changes
		c: recordChange([
			"modalEditor.cut",
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),
		i: recordChange([
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),
		I: recordChange([
			"cursorLineStart",
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),
		a: recordChange([
			"settings.cycle.gitblameOff",
			"modalEditor.setInsertMode",
			"cursorRight"
		]),
		A: recordChange([
			"cursorLineEnd",
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),
		o: recordChange([
			"editor.action.insertLineAfter",
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),
		O: recordChange([
			"editor.action.insertLineBefore",
			"modalEditor.setInsertMode",
			"settings.cycle.gitblameOff"
		]),

		G: {
			command: "modalEditor.gotoLine",
			// line number is prefix count
			computedArgs: true,
			args: "_ctx.count",
			// only when there is a prefix count
			when: "_ctx.count !== undefined"
		},
		
		// match mode
		m: {
			m: "modalEditor.jumpToBracket"
		},

		// goto mode
		g: {
			g: {
				command: "modalEditor.gotoLine",
				// line number is prefix count
				computedArgs: true,
				args: "_ctx.count || 1"
			},
			e: "cursorBottom",
			".": "workbench.action.navigateToLastEditLocation",
			p: "workbench.action.previousEditor",
			n: "workbench.action.nextEditor",
			d: "editor.action.revealDefinition"
		},
		
		// space mode
		" ": {
			// yank to clipboard
			y: [
				{
					command: "modalEditor.yank",
					args: {
						register: ""
					}
				},
				"modalEditor.setNormalMode",
				"settings.cycle.gitblameOn"
			],
			// paste from clipboard
			p: {
				command: "modalEditor.paste",
				args: {
					register: ""
				}
			},
			P: {
				command: "modalEditor.paste",
				args: {
					register: "",
					before: true
				}
			},
			R: [
				"modalEditor.delete",
				{
					command: "modalEditor.paste",
					args: {
						register: "",
						before: true
					}
				}
			],
			f: "workbench.action.quickOpen",
			b: "workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup",
			k: "editor.action.showHover",
			"?": "workbench.action.showCommands"
		},
		
		// search
		"/": "actions.find",
		n: [
			// move right to find the next instead of current
			{
				command: "cursorRight",
				when: "!_ctx.selection.isEmpty"
			},
			"editor.action.nextMatchFindAction",
			{
				// move left because of inclusive range
				command: "cursorLeftSelect",
				when: "!_ctx.selection.isEmpty"
			}
		],
		N: [
			// move right to find the next instead of current
			{
				command: "cursorRight",
				when: "!_ctx.selection.isEmpty"
			},
			"editor.action.previousMatchFindAction",
			{
				// move left because of inclusive range
				command: "cursorLeftSelect",
				when: "!_ctx.selection.isEmpty"
			}
		],

		// Unimpaired
		"[": {
			d: "editor.action.marker.prev",
		},
		"]": {
			d: "editor.action.marker.next",
		},
	},

	normal: {
		// cursor movement
		// clear selection first or it will move before the selection
		h: repeatable(reselect("cursorLeft")),
		j: repeatable(reselect("cursorDown")),
		k: repeatable(reselect("cursorUp")),
		l: repeatable(reselect("cursorRight")),
		w: repeatable(reselect([
			{
				// move right when it's boundary of words, spaces, or newline (only zero or one char if it's newline)
				command: "cursorRight",
				when: "/(^.?$)|(\\s[^\\s])|([^\\s]\\s)|(.\\b.)/.test(_ctx.lineAt(_ctx.pos.line).text.substring(_ctx.pos.character, _ctx.pos.character+2))"
			},
			"cursorWordStartRightSelect",
			// move left because the range is inclusive
			"cursorLeftSelect"
		])),
		b: repeatable(reselect("cursorWordStartLeftSelect")),
		
		// Motions
		f: {
			"": recordMotion(repeatable(reselect({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					select: true
				}`
			})))
		},
		F: {
			"": recordMotion(repeatable(reselect({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					backward: true,
					select: true
				}`
			})))
		},
		t: {
			"": recordMotion(repeatable(reselect({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					till: true,
					select: true
				}`
			})))
		},
		T: {
			"": recordMotion(repeatable(reselect({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					till: true,
					backward: true,
					select: true
				}`
			})))
		},

		// goto mode
		g: {
			h: "cursorLineStart",
			l: [
				"cursorLineEnd",
				{
					// move left if it's not the start of line
					command: "cursorLeft",
					when: "_ctx.pos.character > 0"
				}
			],
		},
	
		// select from cursor to beginning of line
		"0": "cursorLineStartSelect",
		// select from cursor to first non-whitespace character
		"^": "cursorHomeSelect",
		// select from cursor to end of line
		"$": "modalEditor.selectToEndOfLine",
		// select from cursor to end of file
		"%": "cursorBottomSelect",
	
		// set to select mode
		v: "modalEditor.setSelectMode",

		// enter selection search mode
		s: "modalEditor.setSelectionSearchMode",

		// navigate between selections
		"(": "modalEditor.navigateToPreviousSelection",
		")": "modalEditor.navigateToNextSelection",

		// unselect primary selection (Alt+, produces ≤ on macOS)
		"≤": "modalEditor.unselectPrimarySelection"
	},

	select: {
		// cursor movement
		h: repeatable("cursorLeftSelect"),
		j: repeatable("cursorDownSelect"),
		k: repeatable("cursorUpSelect"),
		l: repeatable("cursorRightSelect"),
		w: repeatable([
			{
				// move right when it's boundary of words, spaces, or newline (only zero or one char if it's newline)
				command: "cursorRightSelect",
				when: "/(^.?$)|(\\s[^\\s])|([^\\s]\\s)|(.\\b.)/.test(_ctx.lineAt(_ctx.pos.line).text.substring(_ctx.pos.character, _ctx.pos.character+2))"
			},
			"cursorWordStartRightSelect",
			// move left because the range is inclusive
			"cursorLeftSelect"
		]),
		b: repeatable("cursorWordStartLeftSelect"),
		f: {
			"": repeatable({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					select: true
				}`
			})
		},
		F: {
			"": repeatable({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					backward: true,
					select: true
				}`
			})
		},
		t: {
			"": repeatable({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					till: true,
					select: true
				}`
			})
		},
		T: {
			"": repeatable({
				command: "modalEditor.findText",
				computedArgs: true,
				args: `{
					text: _ctx.keys.charAt(_ctx.keys.length-1),
					till: true,
					backward: true,
					select: true
				}`
			})
		},

		// goto mode
		g: {
			h: "cursorLineStartSelect",
			l: [
				"cursorLineEndSelect",
				{
					// move left if it's not the start of line
					command: "cursorLeftSelect",
					when: "_ctx.pos.character > 0"
				}
			]
		},

		// select from cursor to beginning of line
		"0": "cursorLineStartSelect",
		// select from cursor to first non-whitespace character
		"^": "cursorHomeSelect",
		// select from cursor to end of line
		"$": "modalEditor.selectToEndOfLine",
		// select from cursor to end of file
		"%": "cursorBottomSelect",
	
		// set back to normal mode
		v: ["modalEditor.setNormalMode", "settings.cycle.gitblameOn"],

		// enter selection search mode
		s: "modalEditor.setSelectionSearchMode",

		// navigate between selections
		"(": "modalEditor.navigateToPreviousSelection",
		")": "modalEditor.navigateToNextSelection",

		// unselect primary selection (Alt+, produces ≤ on macOS)
		"≤": "modalEditor.unselectPrimarySelection"
	},

	// Command mode
	command: {
		// save file
		w: "workbench.action.files.save"
	}
};

