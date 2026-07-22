import { createContext, useContext} from "react";

export const UserContext = createContext<number | undefined>(undefined);

export function useUserContext(){
    const User = useContext(UserContext);

    if(User == undefined)
        throw new Error('User was undefined')

    return User;
}