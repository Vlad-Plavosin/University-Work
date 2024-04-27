import React from 'react';
import { render,screen } from '@testing-library/react';
import UpdateForm from './Components/Update';
import { BrowserRouter } from 'react-router-dom';
import '@testing-library/jest-dom/extend-expect';
import { GlassesContext } from './context';
import Glasses from './Components/Glasses';

describe('UpdateForm component', () => {
  test('renders form inputs', () => {
    const mockGlassesData:Glasses[] = [
        { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
        { id: 2, count: 10, color: 'Blue', shape: 'Square', quality: 5, supplier: 'Supplier B' },
      ];
    const { getByLabelText } = render(<BrowserRouter><GlassesContext.Provider value={mockGlassesData}>
        <UpdateForm />
      </GlassesContext.Provider></BrowserRouter>);

    expect(screen.getByText('Quantity')).toBeInTheDocument();
    expect(screen.getByText('Color')).toBeInTheDocument();
    expect(screen.getByText('Shape')).toBeInTheDocument();
    expect(screen.getByText('Quality')).toBeInTheDocument();
    expect(screen.getByText('Supplier')).toBeInTheDocument();
  });
});