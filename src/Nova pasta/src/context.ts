import { createContext, useContext} from "react";

import Glasses from "./Components/Glasses";

export const GlassesContext = createContext<Glasses[] | undefined>(undefined);

export function useGlassesContext(){
    const Glasses = useContext(GlassesContext);

    if(Glasses == undefined)
        throw new Error('Glasses was undefined')

    return Glasses;
}