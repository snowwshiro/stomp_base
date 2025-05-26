import React, { ReactNode } from 'react';

interface LayoutProps {
    children: ReactNode;
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
    return (
        <div>
            <header>
                <h1>Shred Station</h1>
            </header>
            <main>
                {children}
            </main>
            <footer>
                <p>&copy; {new Date().getFullYear()} Shred Station. All rights reserved.</p>
            </footer>
        </div>
    );
};

export { Layout };
export default Layout;
