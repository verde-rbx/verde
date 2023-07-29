local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children

export type ButtonProps = {
	Text: string,
}

return function(_props)
	return New("TextButton") {
		Text = _props.Text,

		[Children] = {
			New("UICorner") {},
		},
	}
end :: Types.Component<ButtonProps>
