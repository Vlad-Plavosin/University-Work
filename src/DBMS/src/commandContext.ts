import { createContext, useContext} from "react";

import Command from "./Components/Comm.tsx";

export const CommandContext = createContext<Command[] | undefined>(undefined);

export function getCommandContext(){
    const Commands = useContext(CommandContext);

    if(Commands == undefined)
        throw new Error('Glasses was undefined')

    return Commands;
}
export function addCommandContext(newCommand:Command){
    const Commands = useContext(CommandContext);
    Commands?.push(newCommand);
}