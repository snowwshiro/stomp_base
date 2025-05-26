import React, { useState } from 'react';
import axios from 'axios';
import type { AxiosError } from 'axios';

interface OutputLine {
    content: string;
    isError: boolean;
}

const Console: React.FC = () => {
    const [input, setInput] = useState<string>('');
    const [output, setOutput] = useState<OutputLine[]>([]);
    
    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
        setInput(e.target.value);
    };

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>): Promise<void> => {
        e.preventDefault();
        try {
            const response = await axios.post('/stomp_base/console/execute', { command: input });
            setOutput(prevOutput => [...prevOutput, { content: response.data, isError: false }]);
            setInput('');
        } catch (error: unknown) {
            let errorMessage = 'Unknown error occurred';
            if (error && typeof error === 'object' && 'message' in error) {
                errorMessage = (error as { message: string }).message;
            }
            setOutput(prevOutput => [...prevOutput, { content: errorMessage, isError: true }]);
        }
    };

    return (
        <div>
            <h1>Rails Console</h1>
            <form onSubmit={handleSubmit}>
                <input 
                    type="text" 
                    value={input} 
                    onChange={handleInputChange} 
                    placeholder="Enter command" 
                />
                <button type="submit">Execute</button>
            </form>
            <div>
                <h2>Output:</h2>
                <pre>
                    {output.map((line, index) => (
                        <div key={index}>
                            {line.isError ? `Error: ${line.content}` : line.content}
                        </div>
                    ))}
                </pre>
            </div>
        </div>
    );
};

export default Console;
