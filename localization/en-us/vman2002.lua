return {
    descriptions = {
        stocking_present = {
            template_stocking_filler_1 = {
                name = 'Example Present',
                text = {
                    '{C:inactive}Does nothing '
                }
            }
        },
        stocking_wrapped_present = {
            template_stocking_present = {
                name = '{V:1}Present',
                text = {
                    '  {C:inactive}What could be inside?  ',
                    '{C:inactive}Open me to find out!'
                }
            },
        }
    }
}
