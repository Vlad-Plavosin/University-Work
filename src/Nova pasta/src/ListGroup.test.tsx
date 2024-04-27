import React from 'react';
import { render,screen } from '@testing-library/react';
import ListGroup from './Components/ListGroup';
import { GlassesContext } from './context';
import Glasses from './Components/Glasses';
import { BrowserRouter } from 'react-router-dom';
import '@testing-library/jest-dom/extend-expect';

const mockGlassesData:Glasses[] = [
  { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
  { id: 2, count: 10, color: 'Blue', shape: 'Square', quality: 5, supplier: 'Supplier B' },
];

describe('ListGroup component', () => {
  test('renders list group with glasses data', () => {
    render(
        <BrowserRouter>
        <GlassesContext.Provider value={mockGlassesData}>
        <ListGroup />
      </GlassesContext.Provider>
        </BrowserRouter>
      
    );
    
    expect(screen.getByText('Glasses List')).toBeInTheDocument();
    expect(screen.getByText('Red')).toBeInTheDocument();
    expect(screen.getByText('Blue')).toBeInTheDocument();
    expect(screen.getByText('Round')).toBeInTheDocument();
    expect(screen.getByText('Square')).toBeInTheDocument();
    expect(screen.getByText('5')).toBeInTheDocument();
    expect(screen.getByText('10')).toBeInTheDocument();
    
  });
});
